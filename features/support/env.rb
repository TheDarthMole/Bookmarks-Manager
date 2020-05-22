require 'capybara'
require 'cucumber'
require 'rspec'
require 'simplecov'
require 'capybara/cucumber'
require 'capybara/dsl'
#require 'warden'
#require 'warden/test/helpers'
#require 'factory_bot'



SimpleCov.start do
    add_filter 'features/'
end

require_relative '../../startServer.rb'

ENV['RACK_ENV'] = 'test'

Capybara.app = Sinatra::Application
Capybara.ignore_hidden_elements = false

# Set selenium as the default driver for javascript
Capybara.javascript_driver = :selenium

# Register chrome browser for the :selenium driver
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

RSpec.configure do |config|
  config.include Capybara::DSL
  #config.include Warden::Test::Helpers
    
end

class Sinatra::ApplicationWorld
    include RSpec::Expectations
    include RSpec::Matchers
    include Capybara::DSL
end

World do
    Sinatra::ApplicationWorld.new
end