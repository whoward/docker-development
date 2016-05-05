
module Dev
  module System
    module_function

    def debug_mode?
      ENV['DEBUG'] == 'true'
    end

    def docker_compose_executable
      Pathname(__config('docker-compose-binary') || __which_docker_compose)
    end

    def __config(key)
      Repository.config[key]
    end

    def __which_docker_compose
      @__which_docker_compose ||= `which docker-compose`.strip
    end
  end
end
