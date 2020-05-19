require_relative "config/application"
Rails.application.load_tasks

Rake::Task[:default].clear unless Rails.env.production?
task default: %i[spec lint]
