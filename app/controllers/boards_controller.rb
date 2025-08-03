class BoardsController < ApplicationController
  before_action :authenticate_user!

# ボード一覧を表示する処理
# ボードと一緒にユーザー情報も読み込む
# 新しい順に並べる
  def index
    @boards = Board.includes(:user).order(created_at: :desc)
  end


# 新しいボードを作成する処理
# @board は空のインスタンス
  def new
    @board = Board.new
  end


# フォームから送信されたデータを受け取り、保存する処理
# ログイン中のユーザーに紐づいた新しいボードを作成
# @board.save でボードを保存できたら、HP（root_path）にリダイレクトして、「作成しました」と表示
# 保存に失敗したらもう一度 new.html.haml を表示
  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to root_path, notice: 'ボードを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

# 外部から直接呼び出せないようにする処理（Strong Parametersの定義）
# フォームで board に関するデータが送られてこないとエラー発生
# title と content のみを許可する
  private
  def board_params
    params.require(:board).permit(:title, :content)
  end

end