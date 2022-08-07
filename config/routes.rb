Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, except: %i[update] do
    resources :answers, shallow: true, except: %i[update]
  end
end
