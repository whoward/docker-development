
module Dev
  module Command
    module Group
      class Add < Command::Base
        attr_reader :name, :entry_names

        def initialize(name:, entries:)
          @name = name
          @entry_names = entries
        end

        def perform
          validate_entries!

          log.info 'nothing to add!' if added.empty?

          added.each { |name| log.info "adding #{name}" }

          group.entry_names.merge(entry_names)

          Repository.save!
        end

        private

        def resolver
          @resolver ||= Resolver.new(Repository.projects, Repository.groups)
        end

        def resolve(name)
          resolver.project_or_group_for_name(name) || unresolved!(name)
        end

        def unresolved!(name)
          raise Dev::Error, "Could not resolve a project or group named #{name.inspect}"
        end

        def validate_entries!
          entry_names.each(&method(:resolve))
        end

        def added
          entry_names - group.entry_names.to_a
        end

        def group
          @group ||= existing_group || create_new_group
        end

        def existing_group
          Repository.groups.find_by(name: name)
        end

        def create_new_group
          log.info "creating new group: #{name}"
          Dev::Group.new(name: name).tap { |g| Repository.groups.add(g) }
        end
      end
    end
  end
end
