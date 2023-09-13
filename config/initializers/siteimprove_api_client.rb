SiteimproveAPIClient.configure do |config|
  config.username = ENV["SITEIMPROVE_API_CLIENT_USERNAME"] || ENV["SITE_IMPROVE_API_CLIENT_USERNAME"]
  config.password = ENV["SITEIMPROVE_API_CLIENT_PASSWORD"] || ENV["SITE_IMPROVE_API_CLIENT_PASSWORD"]
end

Rails.application.config.siteimprove_site_id = ENV["SITEIMPROVE_SITE_ID"] || ENV["SITE_IMPROVE_SITE_ID"]
