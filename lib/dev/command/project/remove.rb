module Dev
  module Command
    module Project
      class Remove < Base
        attr_reader :name

        def initialize(name:, **kwargs)
          @name = name
          super(**kwargs)
        end

        def perform
          Repository.transaction(self) { |me| projects.remove_by!(name: me.name) }
          log.info "Removed #{name.inspect} successfully"
        end
      end
    end
  end
end
