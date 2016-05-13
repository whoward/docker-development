
module Dev
  module Command
    module Config
      class List < Config::Base
        def perform
          return no_config! if Repository.config.empty?

          log.info table.render_with MyBorder
        end

        private

        def no_config!
          log.info 'no configuration'
        end

        def table
          @table ||= TTY::Table.new(Repository.config.to_a)
        end

        class MyBorder < TTY::Table::Border
          def_border do
            left         ''
            center       ' = '
            right        ''
            bottom       ''
            bottom_mid   ''
            bottom_left  ''
            bottom_right ''
          end
        end
      end
    end
  end
end
