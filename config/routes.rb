require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root 'questions#index'

  get '/new_email', to: 'users#new_email'
  post '/confirm_email', to: 'users#confirm_email'

  concern :commented do
    member do
      post :comment
    end
  end

  resources :questions, concerns: %i[commented] do
    resources :answers, concerns: %i[commented], shallow: true do
      resources :votes, module: :answers, shallow: true, only: %i[create destroy]
      patch :select, on: :member
    end
    resources :votes, module: :questions, shallow: true, only: %i[create destroy]
  end

  resource :attachment, only: [:destroy]
  resource :link, only: [:destroy]
  resources :meeds, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, shallow: true, except: %i[new edit]
      end
    end
  end
end
