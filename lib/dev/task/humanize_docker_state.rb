
module Dev
  module Task
    class HumanizeDockerState
      def initialize(state)
        @state = state
      end

      def to_s
        case state['Status']
        when 'exited' then "Exit #{state['ExitCode']}"
        when 'running' then state['Status'].capitalize
        else state.to_json
        end
      end

      private

      attr_reader :state
    end
  end
end
