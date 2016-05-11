require_relative 'command/project'
require_relative 'command/config'
require_relative 'command/stage'

module Dev
  class CLI < Thor
    desc 'project SUBCOMMAND ...ARGS', 'manage your dockerized projects'
    subcommand 'project', Command::Project

    desc 'stage SUBCOMMAND ...ARGS', 'manage the current project stage'
    subcommand 'stage', Command::Stage

    desc 'config SUBCOMMAND ...ARGS', 'configure this development system'
    subcommand 'config', Command::Config

    def self.dispatch(*args, &block)
      super(*args, &block)
    rescue StandardError => exception
      Dev.logger.error(exception)
      exit(1)
    end
  end
end
