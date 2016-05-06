
module Dev
  module Command
    class Stage < Subcommand
      class_option :all, type: :boolean,
                         default: false,
                         aliases: %i(-A),
                         desc: 'apply the command to all your stages'

      desc 'up [project-name]', 'bring up a project'
      def up(*names)
        projects(names).each do |project|
          Dev::Stage.up(project)
          puts "#{project} - up"
        end
      end

      desc 'sync [project-name]', 'synchronizes the docker-compose files for a stage'
      def sync(*names)
        projects(names).each do |project|
          Dev::Stage.sync(project)
          puts "#{project} - synchronized"
        end
      end

      desc 'status [project-name]', 'prints the status of a project'
      def status(*names)
        projects(names).each do |project|
          statuses = Task::FetchContainerStatusForProject.new(project).status

          if statuses.none?
            puts "#{project} - DOWN"
          else
            puts project
            statuses.each do |container, status|
              humanized_status = Task::HumanizeDockerState.new(status)
              puts "\t#{container} - #{humanized_status}"
            end
          end
        end
      end

      private

      def projects(names)
        result = fetch_projects(names)
        if result.empty?
          $stderr.puts 'Nothing to do! Specify at least one project name or add the --all flag'
          exit(1)
        else
          result
        end
      end

      def fetch_projects(names)
        if options[:all]
          Repository.projects
        else
          Repository.projects.find_all_by!(
            name: names.method(:include?).to_proc,
            expect: names.length
          )
        end
      end
    end
  end
end
