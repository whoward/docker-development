
module Dev
  module Command
    module Project
      class List < Base
        def perform
          return no_projects! if projects.empty?

          projects.each do |project|
            table << [project.name, project.path]
          end

          log.info table.render(:unicode, padding: [0, 1, 0, 1])
        end

        private

        def projects
          @projects ||= Repository.projects.sort_by(&:name)
        end

        def no_projects!
          log.info 'No projects'
        end

        def table
          @table ||= TTY::Table.new %w(Name File), []
        end
      end
    end
  end
end
