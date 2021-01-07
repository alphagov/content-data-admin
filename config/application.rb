require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ContentDataAdmin
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # The "acceptance environment" we're in - not the same as Rails env.
    # Can be production, staging, integration, or development
    govuk_environments = {
      "production" => "production",
      "staging" => "staging",
      "integration-blue-aws" => "integration",
    }

    config.govuk_environment = govuk_environments.fetch(ENV["ERRBIT_ENVIRONMENT_NAME"], "development")

    # Load all the locale files and raise execptions if locale missing.
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml")]
    config.action_view.raise_on_missing_translations = true

    # Using a sass css compressor causes a scss file to be processed twice
    # (once to build, once to compress) which breaks the usage of "unquote"
    # to use CSS that has same function names as SCSS such as max.
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil
  end
end
