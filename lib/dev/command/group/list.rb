
module Dev
  module Command
    module Group
      class List < Command::Base
        def perform
          return no_groups! if groups.empty?

          groups.each do |group|
            table << [group.name, group.entry_names.sort.to_a.join(', ')]
          end

          log.info table.render(:unicode, padding: [0, 1, 0, 1])
        end

        private

        def groups
          @groups ||= Repository.groups.sort_by(&:name)
        end

        def no_groups!
          log.info 'No groups'
        end

        def table
          @table ||= TTY::Table.new %w(Name Entries), []
        end
      end
    end
  end
end
