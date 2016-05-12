
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

        def ensure_projects!
          return unless names.empty? && options[:all].nil?
          raise ArgumentError, 'Nothing to do! Specify at least one project name or add the --all flag'
        end

        def projects
          ensure_projects!

          if options[:all]
            projects_repository.projects
          else
            projects_repository.projects.find_all_by!(
              name: names.method(:include?).to_proc,
              expect: names.length
            )
          end
        end
      end
    end
  end
end
