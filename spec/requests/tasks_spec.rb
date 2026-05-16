require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:board)      { create(:board, user: user) }
  let(:task)       { create(:task, user: user, board: board) }

  describe '未ログインのアクセス' do
    it 'GET /boards/:board_id/tasks/:id はログイン画面にリダイレクト' do
      get board_task_path(board, task)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'ログイン済みのアクセス' do
    before { sign_in user }

    describe 'GET /boards/:board_id/tasks/:id' do
      it '200 OK を返す' do
        get board_task_path(board, task)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /boards/:board_id/tasks' do
      context '正常な値の場合' do
        it 'タスクが作成されボード詳細にリダイレクト' do
          expect {
            post board_tasks_path(board), params: {
              task: { title: '新タスク', content: '内容', priority: 'high' }
            }
          }.to change(Task, :count).by(1)
          expect(response).to redirect_to(board_path(board))
        end
      end

      context '不正な値の場合' do
        it 'タスクが作成されず 422 を返す' do
          expect {
            post board_tasks_path(board), params: {
              task: { title: '', content: '' }
            }
          }.not_to change(Task, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /boards/:board_id/tasks/:id' do
      context '自分のタスクの場合' do
        it '更新できタスク詳細にリダイレクト' do
          patch board_task_path(board, task), params: {
            task: { title: '更新タイトル', content: '更新内容' }
          }
          expect(task.reload.title).to eq '更新タイトル'
          expect(response).to redirect_to(board_task_path(board, task))
        end
      end

      context '他人のタスクの場合' do
        it '更新できずタスク詳細にリダイレクト' do
          other_task = create(:task, user: other_user, board: board, title: '元のタイトル')
          patch board_task_path(board, other_task), params: {
            task: { title: '書き換え', content: '書き換え' }
          }
          expect(other_task.reload.title).to eq '元のタイトル'
          expect(response).to redirect_to(board_task_path(board, other_task))
        end
      end
    end

    describe 'DELETE /boards/:board_id/tasks/:id' do
      context '自分のタスクの場合' do
        it '削除できボード詳細にリダイレクト' do
          task
          expect {
            delete board_task_path(board, task)
          }.to change(Task, :count).by(-1)
          expect(response).to redirect_to(board_path(board))
        end
      end

      context '他人のタスクの場合' do
        it '削除できない' do
          other_task = create(:task, user: other_user, board: board)
          expect {
            delete board_task_path(board, other_task)
          }.not_to change(Task, :count)
          expect(response).to redirect_to(board_task_path(board, other_task))
        end
      end
    end
  end
end
