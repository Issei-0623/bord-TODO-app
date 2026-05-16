require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    context '未ログインの場合' do
      it 'ログイン画面にリダイレクトされる' do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'ログイン済みの場合' do
      it '200 OK を返す' do
        sign_in create(:user)
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
