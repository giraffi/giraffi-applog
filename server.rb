raise LoadError, "Ruby 1.9.1 or higher" if RUBY_VERSION < '1.9.1'

require 'rubygems'
require 'sinatra/base'
require 'mongoid'
require 'fiber'
require 'rack/fiber_pool'

Mongoid.configure do |config|
  # Please change 3 params below according to your environment
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

  validates_presence_of :time, :message, :type, :level
  validates_numericality_of :time
end

class Server < Sinatra::Base
  # Include Rack::FiberPool in the stack 
  # and set the number of fibers in the pool (Current default: 100)
  use Rack::FiberPool, :size => 100 unless test?

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

    if applog.save
      status 201 # Created
      applog.to_json
    else
      json_status 400, applog.errors.to_json
    end
  end

  get '/applogs.json' do
    params.delete_if { |k, v| v.empty? }

    applog = nil
    message = params['message'] || nil
    level = params['level'] || nil
    limit = params['limit'] || 0

    if limit.to_i <= 0
      # Initialize with default limit: 10
      limit = 10
    elsif limit.to_i > 100
      # Initialize with max limit: 100
      limit = 100
    end
    
    if message && level
      applog = Applog.all(conditions: {message: /"#{message}"/, level: level}, sort:[["$natural", -1]], limit: limit.to_i)
    elsif message
      applog = Applog.all(conditions: {message: /"#{message}"/}, sort: [["$natural", -1]], limit: limit.to_i)
    elsif level
      applog = Applog.all(conditions: {level: level}, sort: [["$natural", -1]], limit: limit.to_i)
    else
      applog = Applog.all(sort: [["$natural", -1]], limit: limit.to_i)
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
