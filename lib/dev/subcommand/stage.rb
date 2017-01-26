
module Dev
  module Subcommand
    class Stage < Thor::Subcommand
      class_option :all, type: :boolean,
                         default: false,
                         aliases: %i(-A),
                         desc: 'apply the command to all your stages'

      desc 'up [project-name]', 'bring up a project'
      def up(*names)
        Command::Stage::Up.perform(names: names, options: options)
      end

      desc 'down [project-name]', 'stop a project'
      def down(*names)
        Command::Stage::Down.perform(names: names, options: options)
      end

      desc 'sync [project-name]', 'synchronizes the docker-compose stage'
      def sync(*names)
        Command::Stage::Sync.perform(names: names, options: options)
      end

      desc 'rm [project-name]', 'removes the project from the stage'
      def rm(*names)
        Command::Stage::Remove.perform(names: names, options: options)
      end

      desc 'status [project-name]', 'prints the status of a project'
      option :all, type: :boolean, default: false
      def status(*names)
        options[:all] = true if names.empty?
        Command::Stage::Status.perform(names: names, options: options)
      end

      desc 'list', 'list all staged projects'
      def list
        Command::Stage::List.perform(options: options)
      end

      desc 'image [project-name] [image-tag]', 'sets the staged project to use a image'
      def image(name, image)
        Command::Stage::Image.perform(name: name, image: image, options: options)
      end

      desc 'head [project-name]', 'sets the given project to use the local codebase'
      def head(*names)
        sync(*names) # for now this is as simple as re-syncing
      end

      desc 'inspect [project-name]', 'print the normalized docker-compose file of a project'
      def inspect(name)
        Command::Stage::Inspect.perform(name: name, options: options)
      end

      map 'ls' => 'list'
    end
  end
end
