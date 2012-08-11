# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra-scaffold/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shovan Joshi"]
  gem.email         = ["shovanj@gmail.com"]
  gem.description   = %q{sinatra extension to display records from tables}
  gem.summary       = %q{Quick way to display records from tables.}
  gem.homepage      = "http://www.circlingminds.com"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sinatra-scaffold"
  gem.require_paths = ["lib"]
  gem.version       = SinatraScaffold::VERSION
end
