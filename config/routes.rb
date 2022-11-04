Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch :select, on: :member
    end
  end

  resource :attachment, only: [:destroy]
  resource :link, only: [:destroy]
  resources :meeds, only: [:index]
end
