Rails.application.routes.draw do
  devise_for :admins
  root 'home#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
end
