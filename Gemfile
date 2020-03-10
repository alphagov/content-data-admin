ruby File.read(".ruby-version").strip

source "https://rubygems.org"

gem "rails", "~> 5.2"

gem "bootsnap"
gem "chartkick"
gem "fog-aws"
gem "gds-api-adapters"
gem "gds-sso"
gem "govuk_app_config"
gem "govuk_publishing_components"
gem "govuk_sidekiq"
gem "kaminari"
gem "mail-notify"
gem "pg", "~> 1"
gem "plek"
gem "uglifier"

group :test do
  gem "simplecov"
  gem "timecop"
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "byebug"
  gem "capybara"
  gem "factory_bot_rails"
  gem "govuk_test"
  gem "pry"
  gem "rspec-rails"
  gem "rubocop-govuk", "~> 3"
  gem "scss_lint-govuk", "~> 0"
  gem "spring-commands-rspec"
  gem "webmock"
end
