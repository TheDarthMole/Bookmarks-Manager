require 'capybara'
require 'cucumber'
require 'rspec'
require 'simplecov'
require 'capybara/cucumber'
require 'capybara/dsl'

SimpleCov.start do
    add_filter 'features/'
end

require_relative '../../startServer.rb'

ENV['RACK_ENV'] = 'test'

Capybara.app = Sinatra::Application
Capybara.ignore_hidden_elements = false


RSpec.configure do |config|
  config.include Capybara::DSL
end

class Sinatra::ApplicationWorld
    include RSpec::Expectations
    include RSpec::Matchers
    include Capybara::DSL
end



World do
    Sinatra::ApplicationWorld.new
end