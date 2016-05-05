module Dev
  InvalidError = Class.new(Dev::Error)

  class Model
    def validate
      raise NotImplementedError
    end

    def validate!
      reason = validate
      raise InvalidError, reason if reason
    end
  end
end

require_relative 'models/project'
