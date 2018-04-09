# frozen_string_literal: true

Rails.application.routes.draw do
  get '/docs', to: redirect('/docs/swagger-ui/index.html')

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create update]

      post   '/users/login',  to: 'authentication#create'
      delete '/users/logout', to: 'authentication#destroy'
    end
  end
end
