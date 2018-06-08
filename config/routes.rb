# frozen_string_literal: true

Rails.application.routes.draw do
  get '/docs', to: redirect('/docs/swagger-ui/index.html')

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create update] do
        collection do
          get :invites
        end
      end

      resources :households, only: %i[create update] do
        member do
          get :invites
        end

        namespace :join_requests do
          resources :invites, only: %i[create] do
            get :index, to: 'households#invites' # TODO: implement

            member do
              post :accept
              post :decline
            end
          end

          resources :requests, only: %i[create] do
            member do
              post :accept
              post :decline
            end
          end
        end
      end

      post   '/users/login',  to: 'authentication#create'
      delete '/users/logout', to: 'authentication#destroy'
    end
  end
end
