
module Dev
  module Subcommand
    class Config < Thor::Subcommand
      VALID_KEYS = %w(
        docker-compose-binary
        staging-directory
      ).freeze

      InvalidKeyError = Class.new(Dev::Error)

      desc 'list', 'list all configuration'
      def list
        Repository.config.each do |key, value|
          log.info "#{key} = #{value}"
        end
        log.info 'no configuration' if Repository.config.empty?
      end

      desc 'set <key> <value>', 'assign a configuration value'
      def set(key, value)
        key = key.downcase

        raise InvalidKeyError unless VALID_KEYS.include?(key)

        Repository.transaction { config[key] = value }

        log.info "#{key} = #{value}"
      end

      desc 'unset <key>', 'clears the value of the provided key'
      def unset(key)
        key = key.downcase

        raise InvalidKeyError unless VALID_KEYS.include?(key)

        Repository.transaction { config.delete(key) }

        log.info "#{key} unassigned"
      end

      map 'ls' => 'list'

      private

      def log
        Dev.logger
      end
    end
  end
end
