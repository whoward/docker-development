module Dev
  module Command
    module Config
      InvalidKeyError = Class.new(Dev::Error)

      class Base < Command::Base
        VALID_KEYS = %w(
          docker-compose-binary
          staging-directory
          print-stack-traces
        ).freeze

        protected

        def invalid_key!(key)
          raise InvalidKeyError, "#{key} is not a valid configuration key"
        end

        def validate_key!(key)
          key = key.downcase
          invalid_key!(key) unless VALID_KEYS.include?(key)
          key
        end

        def config
          Repository.config
        end
      end
    end
  end
end
