Rails.application.routes.draw do
  get '/docs', to: redirect('/docs/swagger-ui/index.html')

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :update]

      post '/users/login', to: 'sessions#create'
    end
  end
end
