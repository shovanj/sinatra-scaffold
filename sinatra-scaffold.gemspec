# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra-scaffold/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shovan Joshi"]
  gem.email         = ["shovanj@gmail.com"]
  gem.description   = %q{sinatra extension to display records from tables}
  gem.summary       = %q{Quick way to display records from tables.}
  gem.homepage      = "http://www.circlingminds.com"

  gem.add_runtime_dependency 'sinatra', '1.3.2'
  gem.add_runtime_dependency 'mysql2', '0.3.11'
  gem.add_runtime_dependency 'sequel', '3.36.1'
  gem.add_runtime_dependency 'sqlite3', '1.3.6'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sinatra-scaffold"
  gem.require_paths = ["lib"]
  gem.version       = SinatraScaffold::VERSION
end
