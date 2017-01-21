require 'yaml'

module Dev
  module Task
    class ModifyGeneratedDockerCompose
      def initialize(yaml)
        @yaml = parse(yaml)
      end

      def call
        label_application_services!
        yaml.to_yaml
      end

      private

      attr_reader :yaml

      def label_application_services!
        services.each do |_service, service_hash|
          next unless service_hash['build']

          labels = service_hash['labels'] ||= []

          label = ComposeFile::APPLICATION_SERVICE_LABEL

          if labels.is_a?(Array)
            labels << label
          else
            labels[label] = ''
          end
        end
      end

      def services
        yaml.fetch('services', {}).each
      end

      def parse(yaml)
        case yaml
        when String then YAML.load(yaml)
        when Pathname then YAML.load_file(yaml)
        when Hash then yaml
        else raise ArgumentError, "unable to cast #{yaml.inspect} to a Hash"
        end
      end
    end
  end
end
