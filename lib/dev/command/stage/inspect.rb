
module Dev
  module Command
    module Stage
      class Inspect < Command::Base
        def initialize(name:, **options)
          @name = name
          super(options: options)
        end

        # TODO: it would be nice to pass it through pygments to syntax highlight it
        def perform
          ensure_project!

          log.info project.path.read
        end

        private

        attr_reader :name

        def project
          @project ||= Dev::Stage.projects.find_by(name: name)
        end

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
