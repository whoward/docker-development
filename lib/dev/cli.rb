require_relative 'command/project'
require_relative 'command/config'

module Dev
  class CLI < Thor
    desc 'project SUBCOMMAND ...ARGS', 'manage your dockerized projects'
    subcommand 'project', Command::Project

    desc 'config SUBCOMMAND ...ARGS', 'configure this development system'
    subcommand 'config', Command::Config

    def self.dispatch(*args, &block)
      super(*args, &block)
    rescue StandardError => e
      $stderr.puts "#{e.class}: #{e.message}"
      exit(1)
    end
  end
end
