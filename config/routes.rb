Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      resources :votes, module: :answers, shallow: true, only: [:create, :destroy]
      patch :select, on: :member
    end
    resources :votes, module: :questions, shallow: true, only: [:create, :destroy]
  end

  resource :attachment, only: [:destroy]
  resource :link, only: [:destroy]
  resources :meeds, only: [:index]
end
