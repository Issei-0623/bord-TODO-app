require 'rails_helper'

RSpec.describe 'ボード', type: :system do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }

  before { login_as(user, scope: :user) }

  describe 'ボード作成' do
    it 'タイトルと説明を入力して作成できる' do
      visit new_board_path
      fill_in 'タイトル', with: 'テストボード'
      fill_in '概要', with: 'これはテストです'
      click_button '作成'
      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(page).to have_content('テストボード')
    end

    it 'タイトルが空だと作成できない' do
      visit new_board_path
      fill_in 'タイトル', with: ''
      fill_in '概要', with: '説明文'
      click_button '作成'
      expect(page).to have_current_path(new_board_path)
    end
  end

  describe 'ボード一覧' do
    it '作成したボードが一覧に表示される' do
      create(:board, user: user, title: '自分のボード')
      visit boards_path
      expect(page).to have_content('自分のボード')
    end

    it '自分のボードには編集・削除メニューが表示される' do
      create(:board, user: user)
      visit boards_path
      expect(page).to have_css('.dropbtn')
    end

    it '他人のボードには編集・削除メニューが表示されない' do
      create(:board, user: other_user, title: '他人のボード')
      visit boards_path
      expect(page).not_to have_css('.dropbtn')
    end
  end

  describe 'ボード編集' do
    it 'タイトルを変更して保存できる' do
      board = create(:board, user: user, title: '変更前')
      visit edit_board_path(board)
      fill_in 'タイトル', with: '変更後'
      click_button '更新'
      expect(page).to have_current_path(root_path, ignore_query: true)
      expect(board.reload.title).to eq '変更後'
    end
  end
end
