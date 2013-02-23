root_path = File.dirname(__FILE__)

require File.expand_path("../config/application.rb", __FILE__)
use Rack::Reloader, 0

map "/public/javascripts" do
  run Rack::File.new("public/javascripts")
end

map "/views" do
  run Rack::File.new("views")
end

require 'rack/coffee'
use Rack::Coffee,
    :root => root_path,
    :urls => '/assets/coffeescripts/'

run Rack::Cascade.new([
	Rack::File.new('assets/stylesheets'), 
	MonitoramentoPrefeitura
])


