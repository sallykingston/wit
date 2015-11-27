Rails.application.routes.draw do
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end

  root 'home#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'

  # concern :commentable do
  #   resources :comments
  # end

  resources :articles, only: [:index, :show]
  resources :forums, controller: "boards", only: [:index, :show] do
    resources :topics, shallow: true
  end

end
