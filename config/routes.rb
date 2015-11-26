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

  resources :articles, only: [:index, :show]
end
