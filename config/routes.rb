Rails.application.routes.draw do
  resources :questions, only: %i[index new create show] do
    resources :answers, shallow: true, only: %i[list new create show] do
      collection do
        get :list
      end
    end
  end
end
