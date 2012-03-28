# -*- encoding: utf-8 -*-
require File.expand_path('../lib/trello-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['blair christensen']
  gem.email         = ['blair.christensen@gmail.com']
  gem.description   = %q{Trello API client}
  gem.summary       = %q{Trello API client}
  gem.homepage      = 'https://github.com/blairc/trello-client/'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'trello-client'
  gem.require_paths = ['lib']
  gem.version       = Trello::Client::VERSION

  gem.add_runtime_dependency  'multi_json'

  gem.add_development_dependency 'fakeweb'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'rdoc-readme', '~> 0.1.2'
  gem.add_development_dependency 'simplecov'
end

