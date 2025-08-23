Rails.application.routes.draw do
  # Devise の認証ルート
  # `path: ''` により /users/sign_in ではなく /login のような短いパスにする。
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }

  # Devise のスコープ内でのリダイレクト調整。
  # 画面内リンクや古いブックマークで /users/auth_cards /auth_cards に来ても迷わず /login へ送る。
  devise_scope :user do
    get '/users/auth_cards', to: redirect('/login')
    get '/auth_cards',       to: redirect('/login')
  end

  # ホーム画面（最新ボードが並ぶトップ）
  root to: 'home#index'

 # ボード -> タスクの構成
  resources :boards do
    resources :tasks
  end

   # タスク -> コメントの構成
  resources :tasks do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end

  # プロフィールはユーザー1人につき1つなので単数形 resource を使用。
  resource :profile, only: [:show, :edit, :update]

end
