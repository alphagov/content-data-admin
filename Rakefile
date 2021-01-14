require_relative "config/application"
Rails.application.load_tasks

Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task default: %i[lint spec]
