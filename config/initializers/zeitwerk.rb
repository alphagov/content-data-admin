Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "content_items_csv_presenter" => "ContentItemsCSVPresenter",
  )
end

Sidekiq.strict_args!
