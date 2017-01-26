
Dev::Util.require_tree Pathname(__dir__).join('subcommand')
Dev::Util.require_tree Pathname(__dir__).join('command')

module Dev
  class CLI < Thor
    desc 'project SUBCOMMAND ...ARGS', 'manage your dockerized projects'
    subcommand 'project', Subcommand::Project

    desc 'stage SUBCOMMAND ...ARGS', 'manage the current project stage'
    subcommand 'stage', Subcommand::Stage

    desc 'group SUBCOMMAND ...ARGS', 'manage the project groups'
    subcommand 'group', Subcommand::Group

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
