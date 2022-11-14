Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      resources :votes, module: :answers, shallow: true
      patch :select, on: :member
    end
    resources :votes, module: :questions, shallow: true
  end

  resource :attachment, only: [:destroy]
  resource :link, only: [:destroy]
  resources :meeds, only: [:index]
end
