Rails.application.routes.draw do
  resources :stations

  root 'orders#index'

  resource :orders, only: [:create]
end
