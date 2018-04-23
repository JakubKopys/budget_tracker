# frozen_string_literal: true

Rails.application.routes.draw do
  get '/docs', to: redirect('/docs/swagger-ui/index.html')

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create update]
      resources :households, only: %i[create update] do
        namespace :join_requests do
          resources :invites, only: %i[create update destroy] do
            member do
              post :accept
              post :descline
            end
          end

          resources :requests, only: %i[create update destroy]
        end
      end

      post   '/users/login',  to: 'authentication#create'
      delete '/users/logout', to: 'authentication#destroy'
    end
  end
end
