Rails.application.routes.draw do
  resources :questions, only: %w[index new]
end
