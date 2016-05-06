
module Dev
  class Model
    InvalidError = Class.new(Dev::Error)

    def validate
      raise NotImplementedError
    end

    def validate!
      reason = validate
      raise InvalidError, reason if reason
    end
  end
end
