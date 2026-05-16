require 'rails_helper'

RSpec.describe 'Boards', type: :request do
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let(:board)      { create(:board, user: user) }

  describe '未ログインのアクセス' do
    it 'GET /boards はログイン画面にリダイレクト' do
      get boards_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET /boards/:id はログイン画面にリダイレクト' do
      get board_path(board)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'GET /boards/new はログイン画面にリダイレクト' do
      get new_board_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'ログイン済みのアクセス' do
    before { sign_in user }

    describe 'GET /boards' do
      it '200 OK を返す' do
        get boards_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET /boards/:id' do
      it '200 OK を返す' do
        get board_path(board)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'POST /boards' do
      context '正常な値の場合' do
        it 'ボードが作成されルートにリダイレクト' do
          expect {
            post boards_path, params: { board: { title: '新しいボード', content: '説明' } }
          }.to change(Board, :count).by(1)
          expect(response).to redirect_to(root_path)
        end
      end

      context '不正な値の場合' do
        it 'ボードが作成されず 422 を返す' do
          expect {
            post boards_path, params: { board: { title: '', content: '' } }
          }.not_to change(Board, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe 'PATCH /boards/:id' do
      context '自分のボードの場合' do
        it '更新できルートにリダイレクト' do
          patch board_path(board), params: { board: { title: '更新タイトル', content: '更新内容' } }
          expect(board.reload.title).to eq '更新タイトル'
          expect(response).to redirect_to(root_path)
        end
      end

      context '他人のボードの場合' do
        it 'ルートにリダイレクトされ更新できない' do
          other_board = create(:board, user: other_user, title: '元のタイトル')
          patch board_path(other_board), params: { board: { title: '書き換え' } }
          expect(other_board.reload.title).to eq '元のタイトル'
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'DELETE /boards/:id' do
      context '自分のボードの場合' do
        it '削除できルートにリダイレクト' do
          board
          expect {
            delete board_path(board)
          }.to change(Board, :count).by(-1)
          expect(response).to redirect_to(root_path)
        end
      end

      context '他人のボードの場合' do
        it '削除できない' do
          other_board = create(:board, user: other_user)
          expect {
            delete board_path(other_board)
          }.not_to change(Board, :count)
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end
end
