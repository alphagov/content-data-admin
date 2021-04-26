Rails.application.routes.draw do
  root to: redirect("/content")

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  if Rails.env.development? || Rails.application.config.govuk_environment == "integration"
    get "/dev" => "development#index"
  end

  get "/metrics/(*base_path)", to: "metrics#show", as: :metrics, format: false
  get "/content", to: "content#index"
  get "/content/export_csv", to: "content#export_csv"
  get "/help", to: "help#show", as: :show, format: false
  get "/documents/:document_id/children", to: "documents#children", format: false
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
