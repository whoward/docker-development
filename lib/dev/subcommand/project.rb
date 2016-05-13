
module Dev
  module Subcommand
    class Project < Thor::Subcommand
      desc 'add <path>', 'Adds a new docker-compose.yml file to the repository'
      option :name, type: :string,
                    banner: '<project name>',
                    desc: 'provide a custom name for the project'
      def add(path)
        Command::Project::Add.perform(path: path, options: options)
      end

      desc 'remove <name>', 'Removes a project from the repository'
      def remove(name)
        Command::Project::Remove.perform(name: name, options: options)
      end

      desc 'list', 'List all managed projects'
      def list
        Command::Project::List.perform(options: options)
      end

      map 'rm' => 'remove'
      map 'ls' => 'list'
    end
  end
end
