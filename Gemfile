ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 5.2"

gem "bootsnap", "~> 1"
gem "chartkick"
gem "gds-api-adapters", "~> 53"
gem "gds-sso", "~> 13"
gem "govuk_app_config", "~> 1"
gem "govuk_publishing_components", "~> 9.26"
gem 'logstasher'
gem "pg", "~> 1"
gem "plek", "~> 2"
gem "uglifier", "~> 4"

group :development do
  gem "listen", "~> 3"
end

group :test do
  gem "simplecov", "~> 0.16"
end

group :development, :test do
  gem "byebug", "~> 10"
  gem "capybara"
  gem "factory_bot_rails"
  gem "govuk-lint", "~> 3"
  gem "rspec-rails", "~> 3"
  gem "webmock"
end
