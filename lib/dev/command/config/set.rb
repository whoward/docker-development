
module Dev
  module Command
    module Config
      class Set < Config::Base
        attr_reader :key, :value

        def initialize(key:, value:, **kwargs)
          super(**kwargs)
          @key = key
          @value = value
        end

        def perform
          key = validate_key!(@key)

          Repository.transaction(self) { |me| config[key] = me.value }

          log.info "#{key} = #{value}"
        end
      end
    end
  end
end
