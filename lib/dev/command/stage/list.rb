
module Dev
  module Command
    module Stage
      class List < Command::Base
        def perform
          return no_projects! if projects.empty?

          projects.each do |project|
            table << [project.name, project.path, project.compose_file.build_name]
          end

          log.info table.render(:unicode, padding: [0, 1, 0, 1])
        end

        private

        def projects
          @projects ||= Dev::Stage.projects.sort_by(&:name)
        end

        def no_projects!
          log.info 'No projects'
        end

        def table
          @table ||= TTY::Table.new %w(Name File Build), []
        end
      end
    end
  end
end
