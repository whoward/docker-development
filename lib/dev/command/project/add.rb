module Dev
  module Command
    module Project
      class Add < Base
        attr_reader :path

        def initialize(path:, **kwargs)
          @path = Pathname(path)
          super(**kwargs)
        end

        def perform
          name = options.fetch(:name) { path.dirname.basename.to_s }

          Repository.transaction(self) do |me|
            projects.add Dev::Project.new(path: me.path, name: name)
          end

          log.info "Added #{path} successfully"
        end
      end
    end
  end
end
