
# Loading more in this block will cause your tests to run faster. However,
# if you change any configuration or code from libraries loaded here, you'll
# need to restart spork for it take effect.
ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.setup

require 'rack/test'
require 'mongoid'
require 'mongo'

require_relative '../server.rb'

begin
  Mongo::Connection.new('localhost', 27017).close
rescue Mongo::ConnectionFailure
  puts "You will need to have a mongo instance running on localhost"
  puts "for these tests to pass."
  puts "Please make sure `mongod` is running on local port 27017."
end

module RSpecMixinExample
  include Rack::Test::Methods
  def app() Server.new end
end

RSpec.configure { |c| c.include RSpecMixinExample }
