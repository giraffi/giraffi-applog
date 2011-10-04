giraffi-applog
============

A tiny server implementation that collects and aggregates logs generated
by your application. 

Requirements
---------------

* Ruby 1.9.1 or higher
* MongoDB 1.8.x or higher
* Async web server (e.g. thin)

Usage
---------------

__Setup and start server__ (`rake test` is optional) 

     git clone git://github.com/giraffi/giraffi-applog.git giraffi-applog
     cd giraffi-applog/
     gem install bundler
     bundle install --path vendor/bundle
     mongod --nojournal --dbpath ~/mongodb-xxx-xxx_xx-2.0.0/your-dbpath
     rake test      
     bundle exec rackup -s thin -p 3000 config.ru

__Send logs to the server__

     curl -v -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '{"applog":{"message":"logging message","time":1317623935,"type":"app","level":"debug"}}' http://localhost:3000/applogs.json

__Retrieve logs from the server__

     curl -i -X GET 'message=logging&level=debug' http://localhost:3000/applogs.json

__Getting started with Heroku and MongoHQ__

First, create your domain and repository on Heroku.

     cd giraffi-applog/
     heroku create
     Created http://meetings-are-toxic-77.heroku.com/ | git@heroku.com:meetings-are-toxic-77.git

And configure `server.rb` for connecting to your database running on MongoHQ.

     Mongoid.configure do |config|
       ## Please change params below according to your environment.
       ## The settings below is for MongoHQ

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
---------------
azukiwasher, [Github](https://github.com/azukiwasher)
