Rails.application.routes.draw do
  resources :questions, only: %i[index new create show] do
    resources :answers, shallow: true, only: %i[index new create show]
  end
end
