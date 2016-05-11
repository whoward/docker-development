require_relative 'subcommand/project'
require_relative 'subcommand/config'
require_relative 'subcommand/stage'

module Dev
  class CLI < Thor
    desc 'project SUBCOMMAND ...ARGS', 'manage your dockerized projects'
    subcommand 'project', Subcommand::Project

    desc 'stage SUBCOMMAND ...ARGS', 'manage the current project stage'
    subcommand 'stage', Subcommand::Stage

    desc 'config SUBCOMMAND ...ARGS', 'configure this development system'
    subcommand 'config', Subcommand::Config

    def self.dispatch(*args, &block)
      super(*args, &block)
    rescue StandardError => exception
      Dev.logger.error(exception)
      exit(1)
    end
  end
end
