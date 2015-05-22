Rails.application.routes.draw do
  resources :stations

  root 'orders#index'

  resources :orders, only: [:create]

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :orders, only: [:create, :show, :destroy]
      resources :stations, only: [:index]
    end
  end
end
