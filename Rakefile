require 'rake/testtask'

desc "Start server"
task :start do
  system "bundle exec rackup -s thin -p 3000 config.ru"
end

desc "Run tests"
task :test do
  system "bundle exec rspec spec/"
end

task :default => :test
