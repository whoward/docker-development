
module Dev
  module Subcommand
    class Config < Thor::Subcommand
      desc 'list', 'list all configuration'
      def list
        Command::Config::List.perform(options: options)
      end

      desc 'set <key> <value>', 'assign a configuration value'
      def set(key, value)
        Command::Config::Set.perform(key: key, value: value, options: options)
      end

      desc 'unset <key>', 'clears the value of the provided key'
      def unset(key)
        Command::Config::Unset.perform(key: key, options: options)
      end

      map 'ls' => 'list'
    end
  end
end
