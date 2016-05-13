
module Dev
  module Task
    class FetchContainerStatusForProject
      def initialize(project)
        @project = project
      end

      def status
        result = {}

        containers.map do |json|
          name = json['Name'].sub(%r{^/}, '') # remove any leading slash from the name

          result[name] = ContainerStatus.new(json['State'])
        end

        services.each do |service|
          next if result.keys.grep(/_#{service}_/).any?
          result[service] = ContainerStatus::NotCreated
        end

        result
      end

      private

      attr_reader :project

      # Uses the docker-compose CLI to fetch the associated container IDs
      def container_ids
        @container_ids ||= DockerCompose.new(project).container_ids
      end

      def services
        @services ||= DockerCompose.new(project).services
      end

      # gets information about the containers from the Docker API
      def containers
        @containers ||= Docker::Container.all(
          all: true, # include stopped containers
          filters: { id: container_ids }.to_json
        ).map(&:json)
      end
    end
  end
end
