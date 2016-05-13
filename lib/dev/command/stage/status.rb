
module Dev
  module Command
    module Stage
      class Status < Stage::Base
        def perform
          projects.each(&method(:print_status))
        end

        private

        def print_status(project)
          statuses = Task::FetchContainerStatusForProject.new(project).status

          log.info project_summary(project, statuses.values)

          statuses.each do |container, status|
            dot = colored_dot(status.color)
            log.info "  #{dot} #{container} - #{status.human}"
          end
        end

        def project_summary(project, statuses)
          status = ContainerStatus.combine(statuses)

          "#{colored_dot(status.color)} #{project}"
        end

        def colored_dot(color)
          Pastel.new.decorate('•', color)
        end
      end
    end
  end
end
