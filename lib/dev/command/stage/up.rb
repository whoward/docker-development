module Dev
  module Command
    module Stage
      class Up < Stage::Base
        def perform
          projects.each(&method(:up))
        end

        def up(project)
          Dev::Stage.up(project)
          log.info "#{project} - up"
        end

        private

        def missing_project(name)
          project = Repository.projects.find_by(name: name)

          if project
            log.info "synchronizing project #{name.inspect}"
            Dev::Stage.sync(project)
          else
            super
          end
        end
      end
    end
  end
end
