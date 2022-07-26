Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

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
end
