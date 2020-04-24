require "rake/testtask"

# replace the below with the path to your app
# require_relative 'path/to/sinatra_app'

desc "Restore the state of the db"
task :wipedb do
  puts "Wiping the database"
  # ... code to wipe the database ...
end

desc "Delete temporary files"
task :clean => :wipedb do
  `echo deleting temporary files`
  # ... code to delete the database ....
end

desc "Run tests"
Rake::TestTask.new do |t|
  t.pattern = "*_test.rb"
end

desc "Upload all files to the server"
task :upload => [:test, :clean] do
  puts "Uploading files to the server"
  # ... code to upload any files ...
end

desc "Run the Sinatra app locally"
task :run do
  Sinatra::Application.run!
end

