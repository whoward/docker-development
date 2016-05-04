require_relative 'command/app'
require_relative 'command/config'

module Dev
  Error = Class.new(StandardError)

  class CLI < Thor
    desc 'app SUBCOMMAND ...ARGS', 'manage your dockerized applications'
    subcommand 'app', Command::App

    desc 'config SUBCOMMAND ...ARGS', 'configure this development system'
    subcommand 'config', Command::Config

    def self.start(*args, &block)
      Repository.load!
      super(*args, &block)
    end

    def self.dispatch(*args, &block)
      super(*args, &block)
    rescue StandardError => e
      $stderr.puts "#{e.class}: #{e.message}"
      exit(1)
    end
  end
end
