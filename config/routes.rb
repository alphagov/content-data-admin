Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["OK"]] }
  get '/dev' => 'development#index'

  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
