# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra-scaffold/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shovan Joshi"]
  gem.email         = ["shovanj@gmail.com"]
  gem.description   = %q{sinatra extension to display records from tables}
  gem.summary       = %q{Quick way to display records from tables.}
  gem.homepage      = "http://www.circlingminds.com"

  gem.add_runtime_dependency 'sinatra', '1.3.2'
  gem.add_runtime_dependency 'activerecord', '3.2.12'
  gem.add_runtime_dependency 'will_paginate', '3.0.4'

  gem.add_development_dependency 'pg' 
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rack-test'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sinatra-scaffold"
  gem.require_paths = ["lib"]
  gem.version       = SinatraScaffold::VERSION
end
