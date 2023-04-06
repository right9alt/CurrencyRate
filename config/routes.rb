require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server, at: '/cable'

  root "home#index"
  get '/admin', to: 'forced_rates#show'
  
  resources :forced_rates, only: %i[create show]
end
