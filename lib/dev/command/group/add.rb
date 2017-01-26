
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
          return unless validate_entries!

          log.info 'nothing to add!' if added.empty?

          added.each { |name| log.info "adding #{name}" }

          group.entry_names.merge(entry_names)

          Repository.save!
        end

        private

        def validate_entries!
          entry_names.each do |entry|
            elem = Resolve.project_or_group_for_name(entry)
            if elem.nil?
              log.error "Could not find #{entry.inspect}"
              break false
            end
          end
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
          group = Dev::Group.new(name: name)
          Repository.groups.add(group)
          group
        end
      end
    end
  end
end
