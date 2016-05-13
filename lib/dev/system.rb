require_relative 'logger/tty_logger'

module Dev
  module System
    module_function

    def debug_mode?
      ENV['DEBUG'] == 'true'
    end

    def print_stack_traces?
      debug_mode? || config('print-stack-traces') == 'true'
    end

    def docker_compose_executable
      Pathname(config('docker-compose-binary') || which_docker_compose)
    end

    def staging_directory
      Pathname(config('staging-directory') || default_staging_directory)
    end

    def logger
      @logger ||= build_logger
    end

    # private

    def config(key)
      Repository.config[key]
    end

    def which_docker_compose
      @which_docker_compose ||= `which docker-compose`.strip
    end

    def default_staging_directory
      Pathname(Dir.home).join('.dev', 'stage')
    end

    def build_logger
      Logger::TTYLogger
    end
  end
end
