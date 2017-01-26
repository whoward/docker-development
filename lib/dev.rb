require 'thor'
require 'docker-api'
require 'tty'

require 'pathname'

module Dev
  Error = Class.new(StandardError)

  def self.logger
    @logger ||= System.logger
  end
end

require 'dev/util'
require 'dev/subcommand'
require 'dev/cli'
require 'dev/models'
require 'dev/repository'
require 'dev/system'
require 'dev/docker_compose'
require 'dev/compose_file'
require 'dev/stage'
require 'dev/resolver'

Dev::Util.require_tree Pathname(__dir__).join('dev', 'task')
