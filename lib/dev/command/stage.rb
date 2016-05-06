
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

      desc 'down [project-name]', 'stop a project'
      def down(*names)
        projects(names).each do |project|
          DockerCompose.new(project).stop
          puts "#{project} - down"
        end
      end

      desc 'sync [project-name]', 'synchronizes the docker-compose stage'
      def sync(*names)
        projects(names, repository: Dev::Repository).each do |project|
          Dev::Stage.sync(project)
          puts "#{project} - synchronized"
        end
      end

      desc 'rm [project-name]', 'removes the project from the stage'
      def rm(*names)
        projects(names).each do |project|
          Dev::Stage.rm(project)
          puts "#{project} - removed"
        end
      end

      desc 'status [project-name]', 'prints the status of a project'
      option :all, default: true
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

      def projects(names, *args)
        result = fetch_projects(names, *args)
        if result.empty?
          $stderr.puts 'Nothing to do! Specify at least one project name or add the --all flag'
          exit(1)
        else
          result
        end
      end

      def fetch_projects(names, repository: Dev::Stage)
        if options[:all]
          repository.projects
        else
          repository.projects.find_all_by!(
            name: names.method(:include?).to_proc,
            expect: names.length
          )
        end
      end
    end
  end
end
