# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'dev'
  spec.version       = '0.1.0'
  spec.authors       = ['William Howard']
  spec.email         = ['whoward.tke@gmail.com']

  spec.summary       = 'CLI for managing multiple interdependent docker-compose applications in development'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor'
  spec.add_dependency 'docker-api'
  spec.add_dependency 'tty'
end
