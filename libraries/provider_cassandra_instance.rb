require 'uri'
require 'chef/provider'

class Chef
  class Provider
    class CassandraInstance < Chef::Provider

      include ::DseCassandra::Helpers

      def initialize(*args)
        super
        @url = nil
        @checksum = nil
        @download_prefix = nil
        @install_prefix = nil
        @user = nil
        @group = nil
        @data_path = nil
        @log_path = nil
        @config_path = nil
        @runit_template = nil
        @runit_cookbook = nil
        @autorestart = nil
        @options = nil
      end

      def load_current_resource
        @current_resource = Chef::Resource::CassandraInstance.new(@new_resource.name, run_context)
        @current_resource.install_prefix(@new_resource.install_prefix)
        @current_resource
      end

      def instance_path
        ::File.join(@new_resource.install_prefix, @new_resource.name)
      end

      def action_install
        tarball_source = ::URI.parse(@new_resource.url)
        tarball_path = ::File.join(
          @new_resource.download_prefix, ::File.basename(tarball_source.path)
        )

        create_user_and_group(@new_resource.user, @new_resource.group)

        [@new_resource.download_prefix, instance_path].each do |dir|
          dir_resource = Chef::Resource::Directory.new(dir, run_context)
          dir_resource.mode(0755)
          dir_resource.owner(@new_resource.user)
          dir_resource.group(@new_resource.group)
          dir_resource.recursive(true)
          dir_resource.run_action(:create)
        end

        unless @new_resource.checksum
          Chef::Log.warn("cassandra_instance[#{@new_resource.name}] did not specify a checksum, Chef will download the corresponding release on every run")
        end

        tarball_config = {
          :path => tarball_path,
          :url => @new_resource.url,
          :owner => @new_resource.user,
          :group => @new_resource.group
        }

        if @new_resource.checksum
          tarball_config.merge!(:checksum => @new_resource.checksum)
        end

        Chef::Log.info("tarball_config: #{tarball_config.inspect}")

        download_tarball(tarball_config)

        unpack_script = Chef::Resource::Execute.new("unpack_#{tarball_path}", run_context)
        unpack_script.cwd instance_path
        unpack_script.command "tar --strip-components=1 -zxvf #{tarball_path}"
        unpack_script.user @new_resource.user
        unpack_script.group @new_resource.group

        unless ::File.exists?(::File.join(instance_path, 'bin', 'dse'))
          unpack_script.run_action(:run)
        end
      end

      def action_enable
        executable = ::File.join(instance_path, 'bin/dse')
        config_path = @new_resource.config_path || ::File.join(instance_path, 'conf')
        config_file_path = ::File.join(config_path, "#{@new_resource.name}.yml")
        env_dir = ::File.join(instance_path, 'env')

        [config_path, @new_resource.log_path, @new_resource.data_path, env_dir].each do |dir|
          unless ::File.symlink?(dir)
            d = Chef::Resource::Directory.new(dir, run_context)
            d.owner(@new_resource.user)
            d.group(@new_resource.group)
            d.recursive(true)
            d.mode(00755)
            d.run_action(:create)
          end
        end

        svc = Chef::Resource::RunitService.new(@new_resource.name, run_context)
        svc.run_template_name('cassandra')
        svc.log_template_name('cassandra')
        svc.sv_timeout(30)
        svc.cookbook(@new_resource.runit_cookbook || 'dse-cassandra')
        svc.options(
                     :home => instance_path,
                     :user => @new_resource.user,
                     :executable => executable,
                     :config_file => config_file_path
                   )

        # config_file = Chef::Resource::Template.new(config_file_path, run_context)
        # config_file.cookbook(@new_resource.cookbook_name.to_s)
        # config_file.source('cassandra.yml.erb')
        # config_file.owner(@new_resource.user)
        # config_file.group(@new_resource.group)
        # config_file.mode(00644)
        # config_file.variables(
        #                       :name => @new_resource.name,
        #                       :executable => executable,
        #                       :data_path => @new_resource.data_path,
        #                       :logpath => @new_resource.log_path,
        #                       :options => @new_resource.options
        #                       )
        # config_file.notifies(:restart, svc)
        # config_file.run_action(:create)

        svc.run_action(:enable)

        if new_resource.autorestart
          service.run_action(:restart) if config_file.updated_by_last_action?
        end
      end

    end
  end
end
