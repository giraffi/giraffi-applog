require File.expand_path(File.dirname(__FILE__)) + '/server'

use Rack::FiberPool, :size => 100
use Rack::Cache,
  :verbose => true,
  :metastore => 'heap:/',
  :entitystore => 'heap:/'

run Sinatra::Application
