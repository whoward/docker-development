
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

      desc 'remove', 'Remove all or some projects from a group'
      def remove(name, *entries)
        Command::Group::Remove.perform(name: name, entries: entries)
      end

      map 'ls' => 'list'
      map 'rm' => 'remove'
    end
  end
end
