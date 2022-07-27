Rails.application.routes.draw do
  resources :questions, only: %i[index new create show] do
    resources :answers, shallow: true, only: :list do
      collection do
        get :list
      end
    end
  end
end
