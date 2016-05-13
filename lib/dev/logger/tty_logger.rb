
module Dev
  module Logger
    module TTYLogger
      module_function

      def stdout(msg)
        $stdout.puts format(msg)
      end

      def stderr(msg)
        $stderr.puts Pastel.new.red.bold(format(msg))
      end

      def debug(msg)
        stdout(msg) if System.debug_mode?
      end

      class << self
        alias info stdout
        alias warn stdout

        alias error stderr
        alias fatal stderr

        alias unknown stdout
      end

      def format(msg)
        case msg
        when String then msg
        when Dev::Error then format_exception(msg)
        when Exception then format_exception(msg)
        else msg.to_s
        end
      end

      def format_exception(ex)
        if System.debug_mode? || !user_error?(ex)
          "#{ex.class}: #{ex.message}\n  #{ex.backtrace.join("\n  ")}"
        else
          ex.message
        end
      end

      def user_error?(ex)
        ex.is_a?(Dev::Error) || ex.is_a?(Thor::Error)
      end
    end
  end
end
