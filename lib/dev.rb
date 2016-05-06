require 'thor'
require 'docker-api'

require 'pathname'

module Dev
  Error = Class.new(StandardError)
end

require 'dev/subcommand'
require 'dev/cli'
require 'dev/models'
require 'dev/repository'
require 'dev/system'
require 'dev/docker_compose'
require 'dev/stage'

Pathname(__dir__).join('dev')
                 .join('task')
                 .find.select { |p| p.extname == '.rb' }
                 .each { |f| require f }
