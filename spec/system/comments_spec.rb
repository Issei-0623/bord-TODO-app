require 'rails_helper'

RSpec.describe 'コメント', type: :system do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:board)      { create(:board, user: user) }
  let(:task)       { create(:task, user: user, board: board) }

  before { login_as(user, scope: :user) }

  describe 'コメント投稿' do
    it 'コメントを投稿するとタスク詳細に表示される' do
      visit new_task_comment_path(task)
      find('textarea').set('テストコメントです')
      click_button '投稿'
      expect(page).to have_current_path(board_task_path(board, task))
      expect(page).to have_content('テストコメントです')
    end

    it '内容が空だと投稿できない' do
      visit new_task_comment_path(task)
      find('textarea').set('')
      click_button '投稿'
      expect(page).to have_selector('li', text: 'Contentを入力してください', visible: false)
    end
  end

  describe 'コメント表示' do
    it '自分のコメントには編集・削除メニューが表示される' do
      create(:comment, user: user, task: task, content: '自分のコメント')
      visit board_task_path(board, task)
      within('.task-detail--comment-card') do
        expect(page).to have_css('.dropbtn')
      end
    end

    it '他人のコメントには編集・削除メニューが表示されない' do
      create(:comment, user: other_user, task: task, content: '他人のコメント')
      visit board_task_path(board, task)
      within('.task-detail--comment-card') do
        expect(page).not_to have_css('.dropbtn')
      end
    end
  end

  describe 'コメント編集' do
    it 'コメントを編集して保存できる' do
      comment = create(:comment, user: user, task: task, content: '変更前')
      visit edit_task_comment_path(task, comment)
      find('textarea').set('変更後のコメント')
      click_button '更新'
      expect(page).to have_current_path(board_task_path(board, task))
      expect(comment.reload.content).to eq '変更後のコメント'
    end
  end
end
