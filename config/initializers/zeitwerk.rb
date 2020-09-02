Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "content_items_csv_presenter" => "ContentItemsCSVPresenter",
    "exportable_to_csv" => "ExportableToCSV",
  )
end
