Rails.application.routes.draw do
  root to: redirect('/content')

  get "/healthcheck", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck-f", to: proc {
    GovukError.notify('Sentry works')
    [200, {}, ["Sentry notified"]]
  }
  get '/dev' => 'development#index'

  get '/metrics/(*base_path)', to: 'single_page#show', as: :single_page
  get '/csv-metrics/(*base_path)', to: 'metrics#show', as: :metrics
  get '/content', to: 'content#index'
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
