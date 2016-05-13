
module Dev
  module Command
    module Project
      class List < Base
        def perform
          return no_projects! if Repository.projects.empty?

          Repository.projects.each do |project|
            table << [project.name, project.path]
          end

          log.info table.render(:ascii, padding: [0, 1, 0, 1])
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
