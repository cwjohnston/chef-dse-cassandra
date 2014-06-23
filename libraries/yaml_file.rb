require 'yaml'

module CassandraDse
  class YAMLFile
    class << self
      def load_yaml(path)
        YAML.load(File.read(path)) rescue Hash.new
      end

      def dump_yaml(raw_hash)
        YAML.dump(raw_hash) + "\n"
      end

      def to_mash(raw_hash)
        Mash.from_hash(raw_hash)
      end

      def compare_content(path, content)
        to_mash(load_yaml(path)) == to_mash(content)
      end
    end
  end
end
