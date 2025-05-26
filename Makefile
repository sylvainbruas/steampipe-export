# Default target
build: validate_plugin validate_version

	# Remove existing work dir and create a new directory for the render process
	rm -rf work && \
	mkdir -p work

	# Copy the entire source tree, excluding .git directory, into the new directory
	rsync -a --exclude='.git' . work/ >/dev/null 2>&1

	# Change to the new directory to perform operations
	cd work && \
	go run generate/generator.go templates . $(plugin) $(plugin_version) $(plugin_github_url) && \
	if [ ! -z "$(plugin_version)" ]; then \
		echo "go get $(plugin_github_url)@$(plugin_version)" && \
		go get $(plugin_github_url)@$(plugin_version); \
	fi && \
	go mod tidy && \
	$(MAKE) -f out/Makefile build

	# Note: The work directory will contain the full code tree with changes, 
	# binaries will be copied to /usr/local/bin.

# Check if the 'plugin' variable is set
validate_plugin:
ifndef plugin
	$(error "The 'plugin' variable is missing. Usage: make build plugin=<plugin_name> [plugin_version=<version>] [plugin_github_url=<url>]")
endif

# Check if plugin_github_url is provided when plugin_version is specified
validate_version:
ifdef plugin_version
ifndef plugin_github_url
	$(error "The 'plugin_github_url' variable is required when 'plugin_version' is specified")
endif
endif

# render target
render: validate_plugin validate_version
	@echo "Rendering code for plugin: $(plugin)"

	# Remove existing work dir and create a new directory for the render process
	rm -rf work && \
	mkdir -p work

	# Copy the entire source tree, excluding .git directory, into the new directory
	rsync -a --exclude='.git' . work/ >/dev/null 2>&1

	# Change to the new directory to perform operations
	cd work && \
	go run generate/generator.go templates . $(plugin) $(plugin_version) $(plugin_github_url) && \
	if [ ! -z "$(plugin_version)" ]; then \
		echo "go get $(plugin_github_url)@$(plugin_version)" && \
		go get $(plugin_github_url)@$(plugin_version); \
	fi && \
	go mod tidy

	# Note: The work directory will contain the full code tree with rendered changes

# build_from_work target
build_from_work:
	@if [ ! -d "work" ]; then \
		echo "Error: 'work' directory does not exist. Please run the render target first." >&2; \
		exit 1; \
	fi
	@echo "Building from work directory for plugin: $(plugin)"

	# Change to the work directory to perform build operations
	cd work && \
	$(MAKE) -f out/Makefile build

	# Note: This target builds from the 'work' directory and binaries will be copied to /usr/local/bin.

clean:
	rm -rf work

# this target should only be used in the release workflows, running this locally will mutate your source code.
release: validate_plugin validate_version
	go run generate/generator.go templates . $(plugin) $(plugin_version) $(plugin_github_url)
	if [ ! -z "$(plugin_version)" ]; then \
		echo "go get $(plugin_github_url)@$(plugin_version)" && \
		go get $(plugin_github_url)@$(plugin_version); \
	fi
	go mod tidy
	make -f out/Makefile build
