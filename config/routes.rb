Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  get "/healthcheck-f", to: proc {
    GovukError.notify('Sentry works')
    [200, {}, ["Sentry notified"]]
  }
  get '/dev' => 'development#index'

  get '/metrics/:metric/*base_path', to: 'metrics#show'
  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
