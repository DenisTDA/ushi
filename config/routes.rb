Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true do
      patch :select, on: :member
      delete :unattach, on: :member
    end
    delete :unattach, on: :member
  end
end
