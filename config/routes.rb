Rails.application.routes.draw do
  root to: redirect("/content")

  get "/healthcheck/live", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck/ready", to: GovukHealthcheck.rack_response

  get "/metrics/(*base_path)", to: "metrics#show", as: :metrics, format: false

  get "/site-improve-redirect/quality-assurance/(*base_path)", to: "siteimprove_redirect#quality_assurance"
  get "/site-improve-redirect/accessibility/(*base_path)", to: "siteimprove_redirect#accessibility"
  get "/site-improve-redirect/seo/(*base_path)", to: "siteimprove_redirect#seo"
  get "/site-improve-redirect/policy/(*base_path)", to: "siteimprove_redirect#policy"

  get "/content", to: "content#index"
  get "/content/export_csv", to: "content#export_csv"
  get "/documents/:document_id/children", to: "documents#children", format: false
  mount GovukPublishingComponents::Engine, at: "/component-guide" unless Rails.env.production?
end
