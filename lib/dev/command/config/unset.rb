
module Dev
  module Command
    module Config
      class Unset < Config::Base
        def initialize(key:, **kwargs)
          super(**kwargs)
          @key = key
        end

        def perform
          key = validate_key!(@key)

          Repository.transaction { config.delete(key) }

          log.info "#{key} unassigned"
        end
      end
    end
  end
end
