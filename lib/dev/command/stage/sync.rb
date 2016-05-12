module Dev
  module Command
    module Stage
      class Sync < Stage::Base
        def perform
          projects.each(&method(:sync))
        end

        def sync(project)
          Dev::Stage.sync(project)
          log.info "#{project} - synchronized"
        end

        private

        def projects_repository
          Dev::Repository
        end
      end
    end
  end
end
