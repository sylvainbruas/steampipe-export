# Steampipe Export

A family of export tools, each derived from a [Steampipe plugin](https://hub.steampipe.io/plugins), that fetch data from cloud services and APIs.

## Getting Started

You can use an installer that enables you to choose a plugin and download the export tool for that plugin.

**[Installation guide →](https://steampipe.io/docs/steampipe_export/install)**

## Usage

`steampipe_export_aws -h`

```bash
Export data using the aws plugin.

Find detailed usage information including table names, column names, and
examples at the Steampipe Hub: https://hub.steampipe.io/plugins/turbot/aws

Usage:
  steampipe_export_aws TABLE_NAME [flags]

Flags:
      --config string       Inline HCL config data for the connection  (deprecated - use --connection instead)
      --config-dir string   Directory to read config files from (defaults to $STEAMPIPE_INSTALL_DIR/config)
      --connection string   Name of the connection to use (must match a connection defined in the config file)
  -h, --help                help for steampipe_export_aws
      --limit int           Maximum number of rows to return (0 means no limit)
      --output string       Output format: csv, json or jsonl (default "csv")
      --select strings      Columns to include in the output
  -v, --version             version for steampipe_export_aws
      --where stringArray   Optional WHERE clause(s) to filter query results
```

## Examples

### Export EC2 instances using a steampipe connection

```bash
./steampipe_export_aws aws_ec2_instance \
  --connection=aws_prod
```

### Export EC2 instances using a steampipe connection from a steampipe install dir

```bash
./steampipe_export_aws aws_ec2_instance \
  --connection=aws_prod \
  --config-dir='/Users/jack/src/steampipe/config'
```

### Export EC2 instances using an AWS profile

```bash
./steampipe_export_aws aws_ec2_instance \
  --config='profile="dundermifflin"'
```

### Filter to running instances

```bash
./steampipe_export_aws aws_ec2_instance \
  --connection=aws_prod \
  --where="instance_state='running'"
```

### Select a subset of columns

```bash
./steampipe_export_aws aws_ec2_instance \
  --connection=aws_prod \
  --where "instance_state='running'" \
  --select "arn,instance_state"
```

### Limit results

```bash
./steampipe_export_aws aws_ec2_instance \
  --connection=aws_prod \
  --where "instance_state='running'" \
  --select "arn,instance_state" \
  --limit 10
```

## Developing

To build an export tool, use the provided `Makefile`. For example, to build the AWS tool, run the following command to build the tool. It lands in `/usr/local/bin` by default, or elsewhere if you override using the `OUTPUT_DIR` environment variable.

```bash
make build plugin=aws
```

## Open Source & Contributing

This repository is published under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) license. Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) is a product produced exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).
