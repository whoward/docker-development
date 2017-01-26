
module Dev
  module Command
    module Stage
      class Base < Dev::Command::Base
        def initialize(names:, **args)
          super(**args)
          @names = names
        end

        protected

        attr_reader :names

        # overrideable value
        def projects_repository
          Dev::Stage
        end

        def missing_project(name)
          raise Dev::Error, "Could not resolve a project or group named #{name.inspect}"
        end

        private

        def ensure_projects!
          return unless names.empty? && options[:all].nil?
          raise ArgumentError, 'Nothing to do! Specify at least one project name or add the --all flag'
        end

        def projects
          ensure_projects!

          if options[:all]
            projects_repository.projects
          else
            resolved_projects
          end
        end

        def resolver
          @resolver ||= Resolver.new(projects_repository.projects, Repository.groups)
        end

        def resolved_projects
          @resolved ||= begin
            result = resolver.projects_for_names(names)

            result[:missing].each { |name| result[:matches] << missing_project(name) }

            result[:matches]
          end
        end
      end
    end
  end
end
