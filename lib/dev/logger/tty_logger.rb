
module Dev
  module Logger
    module TTYLogger
      module_function

      def stdout(msg)
        out($stdout, msg)
      end

      def stderr(msg)
        out($stderr, Pastel.new.red.bold(msg))
      end

      def debug(msg)
        stdout(msg) if System.debug_mode
      end

      class << self
        alias debug stdout
        alias info stdout
        alias warn stdout

        alias error stderr
        alias fatal stderr

        alias unknown stdout
      end

      def out(io, msg)
        case msg
        when String then io.puts(msg)
        when Dev::Error then io.puts("#{msg.class}: #{msg.message}")
        when Exception then raise msg # TODO: dump with full stack trace
        else io.puts msg.to_s
        end
      end
    end
  end
end
