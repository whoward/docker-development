require 'yaml'

module Dev
  class ComposeFile
    def initialize(data)
      @data = parse_data(data)
    end

    def service_names
      data['services'].map do |service_name, data|
        data.fetch('container_name') { service_name }
      end
    end

    def to_yaml
      data.to_yaml
    end

    private

    attr_reader :data

    def parse_data(data)
      case data
      when String then YAML.parse(data)
      when Pathname then YAML.load_file(data)
      when Hash then data
      end
    end
  end
end
