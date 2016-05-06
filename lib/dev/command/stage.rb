
module Dev
  module Command
    class Stage < Subcommand
      class_option :all, type: :boolean,
                         default: false,
                         aliases: %i(-A),
                         desc: 'apply the command to all your stages'

      desc 'up [project-name]', 'bring up a project'
      def up(*names)
        projects = project(names)

        projects.each do |project|
          Dev::Stage.up(project)
          puts "#{project.name} - up"
        end

        puts 'Nothing to bring up!' if projects.empty?
      end

      desc 'sync [project-name]', 'synchronizes the docker-compose files for a stage'
      def sync(*names)
        projects = projects(names)

        projects.each do |project|
          Dev::Stage.sync(project)
          puts "#{project.name} - synchronized"
        end

        puts 'Nothing to sync!' if projects.empty?
      end

      private

      def projects(names)
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
