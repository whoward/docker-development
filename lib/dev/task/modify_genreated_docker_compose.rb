require 'yaml'

module Dev
  module Task
    # This class fixes errors in docker-compose.yml files generated from the
    # `docker-compose config` command.  It is only intended to work with
    # docker-compose v1.7.0 and will need to be revisited with each iteration
    # of the binary.
    class ModifyGeneratedDockerCompose
      def initialize(yaml)
        @yaml = parse(yaml)
      end

      def call
        clean_network_external_names!
        convert_service_networks_back_to_array!
        label_application_services!
        yaml.to_yaml
      end

      private

      attr_reader :yaml

      def clean_network_external_names!
        return unless yaml['networks'].is_a?(Hash)

        Dev.logger.debug 'cleaning networks -> external_name in generated YAML'

        yaml['networks'].each do |key, _value|
          yaml['networks'][key].delete('external_name')
        end
      end

      def convert_service_networks_back_to_array!
        services.each do |_service, service_hash|
          next unless service_hash['networks'].is_a?(Hash)

          service_hash['networks'] = service_hash['networks'].keys
        end
      end

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
