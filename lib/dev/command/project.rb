
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

        project = Dev::Project.new(path: path, name: name)

        Repository.transaction { add_project(project) }

        puts "Added #{path} successfully"
      end

      desc 'remove <name-or-path>', 'Removes a docker-compose.yml from the repository'
      def remove(name_or_path)
        project = Dev::Project.new(path: name_or_path, name: name_or_path)

        Repository.transaction { remove_project(project) }

        puts "Removed #{name_or_path.inspect} successfully"
      end

      desc 'list', 'List all managed projects'
      def list
        Repository.projects.each { |project| puts "#{project.name}: #{project.path}" }
        puts 'No projects' if Repository.projects.empty?
      end

      map 'rm' => 'remove'
      map 'ls' => 'list'
    end
  end
end
