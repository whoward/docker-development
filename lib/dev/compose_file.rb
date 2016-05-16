require 'yaml'

module Dev
  class ComposeFile
    APPLICATION_SERVICE_LABEL = 'com.influitive.application-service'.freeze

    def initialize(data)
      @data = parse_data(data)
    end

    def service_names
      services.map do |service_name, data|
        data.fetch('container_name') { service_name }
      end
    end

    def build_name
      services = application_services

      return 'N/A' if services.empty?

      _name, data = application_services.first

      if data.key?('image')
        data['image']
      else
        'HEAD'
      end
    end

    def to_yaml
      data.to_yaml
    end

    private

    attr_reader :data

    def services
      data.fetch('services', {}).to_enum
    end

    def application_services
      services.select do |_name, data|
        labels = data.fetch('labels', [])
        labels = labels.keys if labels.is_a?(Hash)
        labels.include?(APPLICATION_SERVICE_LABEL)
      end
    end

    def parse_data(data)
      case data
      when String then YAML.parse(data)
      when Pathname then YAML.load_file(data)
      when Hash then data
      end
    end
  end
end
