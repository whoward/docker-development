
module Dev
  module Command
    class Project < Subcommand
      desc 'add <path>', 'Adds a new docker-compose.yml file to the repository'
      option :name, type: :string,
                    banner: '<project name>',
                    desc: 'provide a custom name for the project'
      def add(path)
        path = Pathname(path)

        name = options.fetch(:name) { path.dirname.basename.to_s }

        Repository.transaction do
          projects.add Dev::Project.new(path: path, name: name)
        end

        log.info "Added #{path} successfully"
      end

      desc 'remove <name>', 'Removes a project from the repository'
      def remove(name)
        Repository.transaction { projects.remove_by!(name: name) }

        log.info "Removed #{name.inspect} successfully"
      end

      desc 'list', 'List all managed projects'
      def list
        Repository.projects.each { |project| log.info "#{project.name}: #{project.path}" }
        log.info 'No projects' if Repository.projects.empty?
      end

      map 'rm' => 'remove'
      map 'ls' => 'list'

      private

      def log
        Dev.logger
      end
    end
  end
end
