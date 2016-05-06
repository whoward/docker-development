
module Dev
  module Task
    class BuildProjectFromStageDirectory
      def initialize(path)
        @path = path
      end

      def project
        Project.new(
          name: path.basename.to_s,
          path: path.join('docker-compose.yml')
        ).tap(&:validate!)
      rescue Dev::Model::InvalidError => e
        invalid_staged_project!(e)
      end

      private

      attr_reader :path

      def invalid_staged_project!(ex)
        raise ex, "the staged project at #{path} is invalid because #{ex.message.inspect}"
      end
    end
  end
end
