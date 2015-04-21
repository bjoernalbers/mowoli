Rails.application.routes.draw do
  resources :stations

  root 'entries#index'

  resource :entries, only: [:create]
end
