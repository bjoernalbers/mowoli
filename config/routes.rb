Rails.application.routes.draw do
  resources :stations
  resources :orders, only: [:new, :index, :create, :show]

  root 'orders#index'

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :orders,   only: [:create, :show, :update, :destroy]
      resources :stations, only: [:index]
    end
  end
end
