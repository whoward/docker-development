
module Dev
  module Command
    class Config < Subcommand
      VALID_KEYS = %w(
        docker-compose-binary
      ).freeze

      InvalidKeyError = Class.new(Dev::Error)

      desc 'list', 'list all configuration'
      def list
        Repository.config.each do |key, value|
          puts "#{key} = #{value}"
        end
        puts 'no configuration' if Repository.config.empty?
      end

      desc 'set <key> <value>', 'assign a configuration value'
      def set(key, value)
        key = key.downcase

        raise InvalidKeyError unless VALID_KEYS.include?(key)

        Repository.transaction { config[key] = value }

        puts "#{key} = #{value}"
      end

      desc 'unset <key>', 'clears the value of the provided key'
      def unset(key)
        key = key.downcase

        raise InvalidKeyError unless VALID_KEYS.include?(key)

        Repository.transaction { config.delete(key) }

        puts "#{key} unassigned"
      end

      map 'ls' => 'list'
    end
  end
end
