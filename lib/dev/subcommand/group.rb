
module Dev
  module Subcommand
    class Group < Thor::Subcommand
      desc 'add <name> [projects...]', 'Adds the projects to the group matching the name.'
      def add(name, *entries)
        Command::Group::Add.perform(name: name, entries: entries)
      end

      desc 'list', 'List all groups currently in the system'
      def list
        Command::Group::List.perform(options: options)
      end

      map 'ls' => 'list'
    end
  end
end
