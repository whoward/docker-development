
module Dev
  module Command
    module Stage
      class Inspect < Stage::Base
        def perform
          projects.each(&method(:print_compose_file))
        end

        private

        # TODO: it would be nice to pass it through pygments to syntax highlight it
        def print_compose_file(project)
          log.info project.path.read
        end
      end
    end
  end
end
