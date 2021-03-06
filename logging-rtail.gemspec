# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logging/plugins/rtail'

Gem::Specification.new do |spec|
  spec.name          = 'logging-rtail'
  spec.version       = Logging::Plugins::Rtail::VERSION
  spec.authors       = ['Will']
  spec.email         = ['wildjim+dev@kiwinet.org']

  spec.summary       = 'An appender for the Logging gem that sends messages to an Rtail server'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/fairfaxmedia/logging-rtail'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'pry-byebug', '~> 3.2'

  spec.add_runtime_dependency 'little-plugger', '~> 1.1'
  spec.add_runtime_dependency 'logging', '~> 2.0'
  spec.add_runtime_dependency 'json', '~> 1.8'
end
