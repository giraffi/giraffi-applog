raise LoadError, "Ruby 1.9.1 or higher" if RUBY_VERSION < '1.9.1'

require 'rubygems'
require 'rack/cache'
require 'sinatra/base'
require 'mongoid'
require 'fiber'
require 'rack/fiber_pool'
require 'pp'
#require 'giraffi_auth'

Mongoid.configure do |config|
  # Please change according to your environment
  host = 'localhost'    
  port = 27017
  name = 'giraffi_applog_development'
  
  config.master = Mongo::Connection.new(host, port).db(name)
  config.persist_in_safe_mode = false  
end

class Applog
  include Mongoid::Document
  field :time, :type => Integer
  field :message 
  field :type 
  field :level 
end

class Server < Sinatra::Base
  # Include Rack::FiberPool in the stack 
  # and set the number of fibers in the pool (Current default: 100)
  use Rack::FiberPool, :size => 100

  #use Rack::Cache do
  #  set :verbose, true
  #  set :metastore, 'heap:/'
  #  set :entitystore, 'heap:/'
  #end

  # Include Applog as model
  #use Server::Applog

  set :root, File.dirname(__FILE__)

  def self.put_or_post(*a, &b)
    put *a, &b
    post *a, &b
  end
 
  helpers do
    def json_status(code, reason)
      status code
      {
        :status => code,
        :reason => reason
      }.to_json
    end
  end

  post '/applogs.json' do
    
    data = JSON.parse request.body.read
    applog = Applog.new(data['applog'])

    if applog.save!
      status 201 # Created
      applog.to_json
    else
      json_status 400, applog.errors.to_hash
      #json_status 400, applog.errors.to_json
    end

  end

  get '/applogs.json' do
   
    data = JSON.parse request.body.read
    message = data['message']
    level = data['level']
    
    if message && level
      applog = Applog.all(conditions: {message: /"#{message}"/, level: level})
    elsif message
      applog = Applog.all(conditions: {message: /"#{message}"/})
    elsif level
      applog = Applog.all(conditions: {level: level})
    else
      applog = nil
    end

    if applog 
      applog.to_json
    else
      json_status 404, "Not found"
    end

  end

  # Handling error, not_found, etc. 
  get '*' do
    status 404
  end  

  put_or_post "*" do
    status 404
  end

  delete "*" do
    status 404
  end

  not_found do
    json_status 404, "Not found"
  end

  error do
    json_status 500, env['sinatra.error'].message
  end
end
