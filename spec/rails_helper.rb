# Must go at top of file
require "simplecov"
SimpleCov.start "rails"

require "byebug"
require "capybara/rspec"
require "webmock/rspec"

WebMock.disable_net_connect!(allow_localhost: true)

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

GovukTest.configure

RSpec.configure do |config|
  config.expose_dsl_globally = false
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods

  # rubocop:disable Rails/SaveBang
  Aws.config.update(stub_responses: true)
  # rubocop:enable Rails/SaveBang
end
