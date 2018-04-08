Rails.application.routes.draw do
  root to: 'pages#index'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update]

      post '/users/login', to: 'sessions#create'
    end
  end
end
