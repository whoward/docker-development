
module Dev
  module Command
    class App < Subcommand
      desc 'add <path>', 'Adds a new docker-compose.yml file to the repository'
      option :name, type: :string,
                    banner: '<app name>',
                    desc: 'provide a custom name for the app'
      def add(path)
        path = Pathname(path)

        name = options.fetch(:name) { path.dirname.basename.to_s }

        app = Dev::App.new(path: path, name: name)

        Repository.transaction { add_app(app) }

        puts "Added #{path} successfully"
      end

      desc 'remove <name-or-path>', 'Removes a docker-compose.yml from the repository'
      def remove(name_or_path)
        app = Dev::App.new(path: name_or_path, name: name_or_path)

        Repository.transaction { remove_app(app) }

        puts "Removed #{name_or_path.inspect} successfully"
      end

      desc 'list', 'List all managed applications'
      def list
        Repository.apps.each { |app| puts "#{app.name}: #{app.path}" }
        puts 'No applications' if Repository.apps.empty?
      end

      map 'rm' => 'remove'
      map 'ls' => 'list'
    end
  end
end
