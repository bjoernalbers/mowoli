Rails.application.routes.draw do
  root 'entries#index'

  resource :entries, only: [:create]
end
