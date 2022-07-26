Rails.application.routes.draw do
  resources :questions, only: %w[index new create show]
end
