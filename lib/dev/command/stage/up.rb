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
      end
    end
  end
end
