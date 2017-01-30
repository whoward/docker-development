
module Dev
  module Command
    module Group
      class Remove < Command::Base
        def initialize(name:, entries:)
          @name = name
          @entries = entries
        end

        def perform
          validate_group!

          if entries.none?
            remove_group!
          else
            remove_entries!
          end

          Repository.save!
        end

        private

        attr_reader :name, :entries

        def group
          @group ||= Repository.groups.find_by(name: name)
        end

        def validate_group!
          group || error("Could not resolve a group named #{name.inspect}")
        end

        def abort!
          error('Will not proceed.')
        end

        def remove_group!
          abort! if prompt.no?("This will remove the group named #{name}, continue?")

          Repository.groups.remove(group)
          log.info "Removed #{name}."
        end

        def remove_entries!
          (group.entry_names & entries).each do |name|
            group.entry_names.delete(name)
            log.info "Removed #{name.inspect}."
          end
        end
      end
    end
  end
end
