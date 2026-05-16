require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:board)      { create(:board, user: user) }
  let(:task)       { create(:task, user: user, board: board) }
  let(:comment)    { create(:comment, user: user, task: task) }

  describe '未ログインのアクセス' do
    it 'GET /tasks/:task_id/comments/new はログイン画面にリダイレクト' do
      get new_task_comment_path(task)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'ログイン済みのアクセス' do
    before { sign_in user }

    describe 'POST /tasks/:task_id/comments' do
      context '正常な値の場合' do
        it 'コメントが作成されタスク詳細にリダイレクト' do
          expect {
            post task_comments_path(task), params: { comment: { content: 'コメント内容' } }
          }.to change(Comment, :count).by(1)
          expect(response).to redirect_to(board_task_path(task.board, task))
        end
      end

      context '不正な値の場合' do
        it 'コメントが作成されず 422 を返す' do
          expect {
            post task_comments_path(task), params: { comment: { content: '' } }
          }.not_to change(Comment, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /tasks/:task_id/comments/:id' do
      context '自分のコメントの場合' do
        it '更新できタスク詳細にリダイレクト' do
          patch task_comment_path(task, comment), params: { comment: { content: '更新コメント' } }
          expect(comment.reload.content).to eq '更新コメント'
          expect(response).to redirect_to(board_task_path(task.board, task))
        end
      end

      context '他人のコメントの場合' do
        it '更新できずタスク詳細にリダイレクト' do
          other_comment = create(:comment, user: other_user, task: task, content: '元のコメント')
          patch task_comment_path(task, other_comment), params: { comment: { content: '書き換え' } }
          expect(other_comment.reload.content).to eq '元のコメント'
          expect(response).to redirect_to(board_task_path(task.board, task))
        end
      end
    end

    describe 'DELETE /tasks/:task_id/comments/:id' do
      context '自分のコメントの場合' do
        it '削除できタスク詳細にリダイレクト' do
          comment
          expect {
            delete task_comment_path(task, comment)
          }.to change(Comment, :count).by(-1)
          expect(response).to redirect_to(board_task_path(task.board, task))
        end
      end

      context '他人のコメントの場合' do
        it '削除できない' do
          other_comment = create(:comment, user: other_user, task: task)
          expect {
            delete task_comment_path(task, other_comment)
          }.not_to change(Comment, :count)
          expect(response).to redirect_to(board_task_path(task.board, task))
        end
      end
    end
  end
end
