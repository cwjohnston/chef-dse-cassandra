# -*- coding: utf-8 -*-
class Chef
  class Resource
    class CassandraInstance < Chef::Resource

      def initialize(name, run_context=nil)
        super
        @resource_name = :cassandra_instance
        @provider = Chef::Provider::CassandraInstance
        @action = :install
        @allowed_actions = [:install, :enable, :disable]

        @name = name
        @url = nil
        @checksum = nil
        @download_prefix = Chef::Config[:file_cache_path]
        @install_prefix = '/opt/cassandra'
        @user = 'cassandra'
        @group = 'cassandra'
        @runit_template = "sv-cassandra-run.erb"
        @runit_cookbook = nil
        @log_path = "/var/log/cassandra"
        @data_path = "/opt/cassandra/data"
        @config_path = nil
        @run_context = run_context
        @run_context.include_recipe("runit")
      end

      def url(arg=nil)
        set_or_return(:url, arg, :kind_of => [String])
      end

      def checksum(arg=nil)
        set_or_return(:checksum, arg, :kind_of => [String, NilClass])
      end

      def download_prefix(arg=nil)
        set_or_return(:download_prefix, arg, :kind_of => [String])
      end

      def install_prefix(arg=nil)
        set_or_return(:install_prefix, arg, :kind_of => [String])
      end

      def user(arg=nil)
        set_or_return(:user, arg, :regex => [Chef::Config[:user_valid_regex]])
      end

      def group(arg=nil)
        set_or_return(:group, arg, :regex => [Chef::Config[:group_valid_regex]])
      end

      def data_path(arg=nil)
        set_or_return(:data_path, arg, :kind_of => [String])
      end

      def log_path(arg=nil)
        set_or_return(:log_path, arg, :kind_of => [String])
      end

      def config_path(arg=nil)
        set_or_return(:config_path, arg, :kind_of => [String])
      end

      def runit_run_template(arg=nil)
        set_or_return(:runit_run_template, arg, :kind_of => [String])
      end

      def runit_log_template(arg=nil)
        set_or_return(:runit_log_template, arg, :kind_of => [String])
      end

      def runit_cookbook(arg=nil)
        set_or_return(:config_cookbook, arg, :kind_of => [String])
      end

      def autorestart(arg=nil)
        set_or_return(:autorestart, arg, :kind_of => [TrueClass, FalseClass])
      end

      def options(arg=nil)
        set_or_return(:options, arg, :kind_of => [Hash])
      end
    end
  end
end
