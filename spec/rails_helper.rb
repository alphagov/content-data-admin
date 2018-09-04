require "byebug"
require 'capybara/rspec'
require 'webmock/rspec'

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../config/environment', __dir__)
require "rspec/rails"

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
if ENV["TEST_COVERAGE"] == "true"
  require "simplecov"
  SimpleCov.start
end

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.infer_spec_type_from_file_location!
end
