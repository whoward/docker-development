
module Dev
  # this is a model wrapper for the API structure of a container status.
  # I've taken the liberty of adding a few extra 'meta-states' to represent
  # statuses that don't make sense from docker's container perspective:
  # - Not Created
  # - Down
  # - Partial
  class ContainerStatus
    def self.combine(statuses)
      return NotCreated if statuses.none?

      if statuses.all?(&:running?)
        new('Status' => 'running')
      elsif statuses.any?(&:running?)
        Partial
      else
        Down
      end
    end

    def initialize(data)
      @data = data
    end

    NotCreated = new('Status' => 'not_created').freeze
    Down = new('Status' => 'down').freeze
    Partial = new('Status' => 'partial').freeze

    def human
      case status
      when 'exited' then "Exit #{exit_code}"
      when 'running' then status.capitalize
      when 'not_created' then 'Not created'
      when 'down' then 'Down'
      else data.to_json
      end
    end

    def color
      case status
      when 'running' then :green
      when 'exited', 'not_created', 'down' then :red
      else :yellow
      end
    end

    def running?
      status == 'running'
    end

    private

    attr_reader :data

    def status
      data['Status']
    end

    def exit_code
      data['ExitCode']
    end
  end
end
