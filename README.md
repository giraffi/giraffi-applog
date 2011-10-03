giraffi-applog
============

A server implementation that collects and aggregates logs generated
by your application. 

Requirements
---------------

* Ruby 1.9.1 or higher
* MongoDB 1.9.x or higher
* EventMachine based async web server (e.g. thin)

Usage
---------------

Setup and start server:

     git clone git@git1.xenzai.com:mxenzai/giraffi-applog.git giraffi-applog 
     cd giraffi-applog/
     gem install bundler
     bundle install --path vendor/bundle
     bundle exec rackup -s thin -p 3000 config.ru

Send logs to the server:

   curl -v -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '{"applog":{"message":"logging message","time":1317623935,"type":"app","level":"debug"}}' http://localhost:3000/applogs.json

Retrieve logs from the server:

   curl -i -X GET 'message=logging&level=debug' http://localhost:3000/applogs.json

Getting started with Heroku and mongoHQ:

Create your domain and repository on Heroku 

   cd giraffi-applog/
   heroku create
   Created http://meetings-are-toxic-77.heroku.com/ | git@heroku.com:meetings-are-toxic-77.git      

Configure "server.rb" for connectiong to your database running on MongoHQ

   Mongoid.configure do |config|
     ## Please change params below according to your environment.
     #  mongoHQ

     host = 'staff.mongohq.com'    
     port = 10099
     db_name  = 'hq_database'
     username = 'hq_username'
     password = 'hq_password'

     config.master = Mongo::Connection.new(host, port).db(db_name)
     config.master.authenticate(username, password)

     config.persist_in_safe_mode = false  
   end


Author
=======
azukiwasher, [Github](https://github.com/azukiwasher)
