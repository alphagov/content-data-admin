require_relative "config/application"
Rails.application.load_tasks

Rake::Task[:default].clear
task default: %i[spec lint]
