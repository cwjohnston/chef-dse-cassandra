# dse-cassandra cookbook

## Notice

This cookbook is under active development, and its public interface may change.

What this warning means is that the attributes, and actions used by `cassandra_instance`
and any other resources implemented here may drastically change. When using this cookbook
please reference an exact SHA commit from this repository to ensure continuous functionality.

## Description

This cookbook implements Chef resource providers for the installation and configuraiton of Datastax Enterprise Cassandra. It does not aim to support the community edition of Cassandra.

Because Datastax Enterprise Cassandra is a commercial product, use of this cookbook will tend to require unique download credentials obtained from Datastax.

## Resources


### cassandra_instance

The `cassandra_instance` resource defines a something.

```ruby
# this example will fail with a 401, as the URL does not include required credentials
cassandra_instance "cassandra" do
  url "https://downloads.datastax.com/enterprise/dse-4.0.3-bin.tar.gz"
  checksum "d2be416baf5ddb2cce6f3252df80de8818a5a5ab18a8cd3ece2d747ccf0150c4"
  action [:install, :enable]
end
```

* `url` – URL for a tarball containing a Datastax Enterprise Cassandra release
* `checksum` - sha256 checksum corresponding to the above tarball (optional)
* `download_prefix` - download path for above tarball, defaults to `Chef::Config[:file_cache_path]`
* `user` - user for cassandra instance to run under, defaults to `cassandra`
* `group` - group created for above user, defaults to `cassandra`
* `install_prefix` - directory prefix for the instance to be installed, defaults to `/opt/cassandra`
* `log_path` - directory path for cassandra instance logs, defaults to `/var/log/cassandra`
* `data_path` - directory path for cassandra data, defaults to `/opt/cassandra/data`
* `config_path` - directory path for cassandra configuration, defaults to `/opt/cassandra/#{instance_name}/config`
* `runit_template` - name of template source to override the runit service script provided by this cookbook
* `runit_cookbook` - name of cookbook cooresponding with the above runit service script template

## Quick Start

See the included test recipe in `tests/cookbooks/dse-cassandra-test` for an example.

## Testing

This cookbook uses test-kitchen for testing. In order to these tests, please set the `DSE_CASSANDRA_USERNAME` and `DSE_CASSANDRA_PASSWORD` environment variables to reflect your unique credentials for downloading Datastax Enterprise Cassandra