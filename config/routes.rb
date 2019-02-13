Rails.application.routes.draw do
  root to: redirect('/content')

  get "/healthcheck", to: proc { [200, {}, %w[OK]] }
  get "/healthcheck-f", to: proc {
    GovukError.notify('Sentry works')
    [200, {}, ["Sentry notified"]]
  }

  if Rails.env.development? || Rails.application.config.govuk_environment == 'integration'
    get '/dev' => 'development#index'
  end

  get '/metrics/(*base_path)', to: 'metrics#show', as: :metrics, format: false
  get '/content', to: 'content#index'
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
