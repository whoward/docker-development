module Dev
  module Command
    module Stage
      class Down < Stage::Base
        def perform
          projects.each(&method(:down))
        end

        def down(project)
          Dev::Stage.down(project)
          log.info "#{project} - down"
        end
      end
    end
  end
end
