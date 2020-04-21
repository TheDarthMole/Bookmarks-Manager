require 'capybara'
require 'cucumber'
require 'rspec'
require 'simplecov'
require 'capybara/cucumber'

SimpleCov.start do
    add_filter 'features/'
end

#is that file extension alright? 
require_relative '../../startServer.rb'

ENV['RACK_ENV'] = 'test'

Capybara.app = Sinatra::Application

class Sinatra::ApplicationWorld
    include RSpec::Expectations
    include RSpec::Matchers
    include Capybara::DSl
end

World do
    Sinatra::ApplicationWorld.new
end