Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }

  devise_scope :user do
    get '/users/auth_cards', to: redirect('/login')
    get '/auth_cards',       to: redirect('/login')
  end

  root to: 'home#index'

  resources :boards do
    resources :tasks
  end

  resources :tasks do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :comments, only: [:new, :create, :edit, :update, :destroy]

  resource :profile, only: [:show, :edit, :update]

end
