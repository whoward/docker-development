
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
        when Dev::Error then format_exception(msg) # TODO: only dump a backtrace if configured to
        when Exception then format_exception(msg)
        else msg.to_s
        end
      end

      def format_exception(ex)
        "#{ex.class}: #{ex.message}\n  #{ex.backtrace.join("\n  ")}"
      end
    end
  end
end
