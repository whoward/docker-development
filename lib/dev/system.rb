
module Dev
  module System
    module_function

    def debug_mode?
      ENV['DEBUG'] == 'true'
    end

    # TODO: make configurable
    def docker_compose_executable
      Pathname(__which_docker_compose)
    end

    def __which_docker_compose
      @__which_docker_compose ||= `which docker-compose`.strip
    end
  end
end
