
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
          ensure_project!

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
          @project ||= Dev::Stage.projects.find_by(name: name)
        end

        # TODO: sync the project if it is not already synced
        def ensure_project!
          project || no_project!
        end

        def no_project!
          raise Dev::Error, "could not resolve a staged project named #{name}"
        end
      end
    end
  end
end
