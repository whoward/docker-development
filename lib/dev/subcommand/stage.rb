
module Dev
  module Subcommand
    class Stage < Thor::Subcommand
      class_option :all, type: :boolean,
                         default: false,
                         aliases: %i(-A),
                         desc: 'apply the command to all your stages'

      desc 'up [project-name]', 'bring up a project'
      def up(*names)
        projects(names).each do |project|
          Dev::Stage.up(project)
          log.info "#{project} - up"
        end
      end

      desc 'down [project-name]', 'stop a project'
      def down(*names)
        projects(names).each do |project|
          DockerCompose.new(project).stop
          log.info "#{project} - down"
        end
      end

      desc 'sync [project-name]', 'synchronizes the docker-compose stage'
      def sync(*names)
        projects(names, repository: Dev::Repository).each do |project|
          Dev::Stage.sync(project)
          log.info "#{project} - synchronized"
        end
      end

      desc 'rm [project-name]', 'removes the project from the stage'
      def rm(*names)
        projects(names).each do |project|
          Dev::Stage.rm(project)
          log.info "#{project} - removed"
        end
      end

      desc 'status [project-name]', 'prints the status of a project'
      option :all, default: true
      def status(*names)
        projects(names).each do |project|
          statuses = Task::FetchContainerStatusForProject.new(project).status

          if statuses.none?
            log.info "#{project} - DOWN"
          else
            log.info project
            statuses.each do |container, status|
              humanized_status = Task::HumanizeDockerState.new(status)
              log.info "\t#{container} - #{humanized_status}"
            end
          end
        end
      end

      private

      def log
        Dev.logger
      end

      def projects(names, *args)
        result = fetch_projects(names, *args)
        if result.empty?
          log.error 'Nothing to do! Specify at least one project name or add the --all flag'
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
