require 'rails_helper'

RSpec.describe '認証', type: :system do
  describe 'ログイン' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    it 'メールとパスワードでログインできる' do
      visit new_user_session_path
      fill_in 'Eメール', with: 'test@example.com'
      fill_in 'パスワード', with: 'password123'
      click_button '送信'
      expect(page).to have_current_path(root_path, ignore_query: true)
    end

    it 'パスワードが間違っているとログインできない' do
      visit new_user_session_path
      fill_in 'Eメール', with: 'test@example.com'
      fill_in 'パスワード', with: 'wrongpassword'
      click_button '送信'
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe 'ログアウト' do
    it 'ログアウトするとログイン画面に戻る' do
      user = create(:user)
      login_as(user, scope: :user)
      visit root_path
      find('.menu-btn').click
      click_on 'ログアウト'
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe '未ログインのリダイレクト' do
    it 'トップページにアクセスするとログイン画面に飛ぶ' do
      visit root_path
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
