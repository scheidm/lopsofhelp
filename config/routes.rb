Rails.application.routes.draw do
  root 'pages#index'

  resources :greenspaces, only: %i[show index]
  resources :cities, only: %i[show index]
  resources :pages, only: %i[show index]
  match '*uri', to: 'pages#not_found', via: :all
end
