require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('scaffold', '0.0.1') do |p|
  p.description    = "Generate basic scaffolding for models"
  p.url            = "http://github.com/terrapin/sinatra-scaffold"
  p.author         = "Shovan Joshi"
  p.email          = "shovanj@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.runtime_dependencies = ["thor"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
