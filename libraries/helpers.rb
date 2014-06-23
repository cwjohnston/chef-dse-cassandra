require 'chef/provider/user'
require 'chef/resource/user'
require 'chef/provider/group'
require 'chef/resource/group'

module DseCassandra
  module Helpers

    private

    def download_tarball(config={})
      f = Chef::Resource::RemoteFile.new(config[:path], run_context)
      f.source config[:url]
      f.checksum config[:checksum] if config[:checksum]
      f.owner config[:owner]
      f.group config[:group]
      f.run_action(:create)
    end

    def create_user_and_group(username, groupname)
      new_group = Chef::Resource::Group.new(groupname, run_context)

      new_user = Chef::Resource::User.new(username, run_context)
      new_user.gid(groupname)

      new_group.run_action(:create)
      new_user.run_action(:create)
    end

    # Finds a resource if it exists in the collection.
    # @param type [String] The resources proper name, eg CassandraRelease or CassandraInstance
    # @param name [String] The unique name of that resource.
    # @return [Resource] Hopefully the resource object you were looking for.
    #
    def lookup_resource(type, name, run_context)
      begin
        run_context.resource_collection.find("#{ type }[#{ name }]")
      rescue ArgumentError => e
        puts "You provided invalid arugments to resource_collection.find: #{ e }"
      rescue RuntimeError => e
        puts "The resources you searched for were not found: #{ e }"
      end
    end

    def lookup_instance(name, run_context)
      lookup_resource(:cassandra_instance, name, run_context)
    end

  end
end
