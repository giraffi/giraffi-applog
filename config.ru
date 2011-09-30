require File.expand_path(File.dirname(__FILE__)) + '/server'
require 'rack/fiber_pool'

# Include Rack::FiberPool in the stack 
# and set the number of fibers in the pool (Current default: 100)
use Rack::FiberPool, :size => 100
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

server = Server.new do

end
run server
