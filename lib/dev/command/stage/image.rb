
module Dev
  module Command
    module Stage
      class Image < Command::Base
        def initialize(name:, image:, **kwargs)
          super(**kwargs)
          @name = name
          @image = image
        end

        def perform
          # bring any running services down
          DockerCompose.new(project).stop

          # update the yaml file
          yaml = project.compose_file
                        .tap { |f| f.application_container_image = image }
                        .to_yaml

          project.path.write(yaml)

          # TODO: if there were running containers then bring them back up
        end

        private

        attr_reader :name, :image

        def project
          Dev::Stage.projects.find_by(name: name)
        end
      end
    end
  end
end
