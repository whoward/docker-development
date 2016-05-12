module Dev
  module Command
    module Stage
      class Remove < Stage::Base
        def perform
          projects.each(&method(:remove))
        end

        def remove(project)
          Dev::Stage.remove(project)
          log.info "#{project} - removed"
        end
      end
    end
  end
end
