require 'rails_helper'

RSpec.describe 'タスク', type: :system do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:board)      { create(:board, user: user) }

  before { login_as(user, scope: :user) }

  describe 'タスク作成' do
    it 'ボード詳細ページからタスクを追加できる' do
      visit board_path(board)
      fill_in 'タイトル', with: '新しいタスク'
      fill_in '内容', with: 'タスクの内容'
      click_button '作成'
      expect(page).to have_current_path(board_path(board))
      expect(page).to have_selector('.task-title', text: '新しいタスク', visible: false)
    end

    it 'タイトルが空だと作成できない' do
      visit board_path(board)
      fill_in 'タイトル', with: ''
      fill_in '内容', with: '内容だけ'
      click_button '作成'
      expect(page).to have_selector('li', text: 'タイトルを入力してください', visible: false)
    end
  end

  describe 'タスク詳細' do
    it 'タスクのタイトルと内容が表示される' do
      task = create(:task, user: user, board: board, title: 'タスク詳細テスト', content: '詳細内容')
      visit board_task_path(board, task)
      expect(page).to have_content('タスク詳細テスト')
      expect(page).to have_content('詳細内容')
    end

    it '自分のタスクには編集・削除メニューが表示される' do
      task = create(:task, user: user, board: board)
      visit board_task_path(board, task)
      expect(page).to have_css('.dropbtn')
    end

    it '他人のタスクには編集・削除メニューが表示されない' do
      task = create(:task, user: other_user, board: board)
      visit board_task_path(board, task)
      expect(page).not_to have_css('.dropbtn')
    end
  end

  describe 'タスク編集' do
    it 'タイトルと内容を変更して保存できる' do
      task = create(:task, user: user, board: board, title: '変更前')
      visit edit_board_task_path(board, task)
      fill_in 'タイトル', with: '変更後'
      click_button '更新'
      expect(page).to have_current_path(board_task_path(board, task))
      expect(task.reload.title).to eq '変更後'
    end
  end
end
