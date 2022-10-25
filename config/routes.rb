Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch :select, on: :member
    end
  end

  resource :attachment, only: [:unattach] do
    delete :unattach, on: :member
  end
end
