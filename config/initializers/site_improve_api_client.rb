SiteImproveAPIClient.configure do |config|
  config.username = ENV['SITE_IMPROVE_API_CLIENT_USERNAME']
  config.password = ENV['SITE_IMPROVE_API_CLIENT_PASSWORD']
end

Rails.application.config.site_improve_site_id = ENV['SITE_IMPROVE_SITE_ID']
