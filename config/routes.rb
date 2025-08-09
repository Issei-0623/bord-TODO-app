Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  resources :boards do
    resources :tasks
  end

  resources :tasks do
    resources :comments, only: [:new, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check

  get "users/auth_cards", to: "users#auth_cards"

end
