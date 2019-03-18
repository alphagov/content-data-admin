require "byebug"
require 'capybara/rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../config/environment', __dir__)
require "rspec/rails"

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
if ENV["TEST_COVERAGE"] == "true"
  require "simplecov"
  SimpleCov.start
end

GovukTest.configure

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods
end
