require 'shellwords'
require 'open3'

module Dev
  # a wrapper around the docker-compose command line interface
  class DockerCompose
    NotInstalledError = Class.new(Dev::Error)
    CommandFailed = Class.new(Dev::Error)

    def self.executable
      System.docker_compose_executable
    end

    def self.ensure_installed!
      executable.instance_exec { file? && executable? } ||
        raise(NotInstalledError, 'docker-compose is not present or is not executable')
    end

    def initialize(project)
      @project = project
    end

    # executes docker-compose with the given arguments
    def command(*arguments)
      self.class.ensure_installed!

      Dir.chdir(project.directory) do
        command = build_command(arguments)

        stdout, status = Open3.capture2(command)

        puts stdout if System.debug_mode?

        command_failed!(command, status) unless status.success?

        stdout.strip
      end
    end

    def up(detached: true, flags: [])
      flags.unshift('-d') if detached

      command :up, *flags
    end

    # returns the normalized docker-compose.yml configuration
    def configuration
      command :config
    end

    # returns a list of all services in the docker-compose file
    # N.B. the services do not have the project name prefix nor the scale suffix
    #      which you find on container names
    def services
      command(:config, '--services').split
    end

    # returns a partially parsed hash of versions, if you need more you need
    # to use the rubypython gem instead to connect to the library directly
    def version
      command(:version).split(/\n/)
                       .map { |v| v.split(/\s*version:?\s*/) }
                       .to_h
    end

    def container_ids
      command(:ps, :'-q').split(/\n/)
    end

    private

    attr_reader :project

    def build_command(arguments)
      Shellwords.join [
        self.class.executable,
        '--project-name', project.name,
        *arguments
      ]
    end

    def command_failed!(command, status)
      raise CommandFailed, "#{command.inspect} failed with status #{status.to_i}"
    end
  end
end
