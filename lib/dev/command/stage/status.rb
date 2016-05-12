
module Dev
  module Command
    module Stage
      class Status < Stage::Base
        def perform
          projects.each(&method(:print_status))
        end

        def print_status(project)
          statuses = Task::FetchContainerStatusForProject.new(project).status

          log.info project_summary(project, statuses.values)

          statuses.each do |container, status|
            dot = colored_dot(color_for_status(status['Status']))
            humanized_status = Task::HumanizeDockerState.new(status)
            log.info "  #{dot} #{container} - #{humanized_status}"
          end
        end

        def colored_dot(color)
          Pastel.new.decorate('•', color)
        end

        def project_summary(project, statuses)
          color = statuses.none? ? :red : project_status_color(statuses)

          "#{colored_dot(color)} #{project}"
        end

        def project_status_color(statuses)
          statuses = statuses.map { |s| color_for_status(s['Status']) }.uniq

          if statuses.include?(:red)
            :red
          elsif statuses.include?(:yellow)
            :yellow
          else
            :green
          end
        end

        def color_for_status(status)
          case status
          when 'running' then :green
          when 'exited', 'not_created' then :red
          else :yellow
          end
        end
      end
    end
  end
end
