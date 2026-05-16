require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  let(:user) { create(:user) }

  describe '未ログインのアクセス' do
    it 'GET /profile はログイン画面にリダイレクト' do
      get profile_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET /profile/edit はログイン画面にリダイレクト' do
      get edit_profile_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'ログイン済みのアクセス' do
    before { sign_in user }

    describe 'GET /profile' do
      it '200 OK を返す' do
        get profile_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /profile/edit' do
      it '200 OK を返す' do
        get edit_profile_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'PUT /profile' do
      context '正常な値の場合' do
        it 'プロフィールが更新されルートにリダイレクト' do
          put profile_path, params: { profile: { nickname: '新ニックネーム' } }
          expect(user.reload.profile.nickname).to eq '新ニックネーム'
          expect(response).to redirect_to(profile_path)
        end
      end
    end
  end
end
