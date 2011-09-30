require File.expand_path(File.dirname(__FILE__)) + '/server'

use Rack::FiberPool, :size => 100

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

server = Server.new
run server
