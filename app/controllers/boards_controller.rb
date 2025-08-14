class BoardsController < ApplicationController
  before_action :set_board, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

# ボード一覧を表示する処理
# ボードと一緒にユーザー情報も読み込む
# 新しい順に並べる
  def index
    per_page = params[:per_page].presence&.to_i
    per_page = 5 if per_page.nil? || per_page <= 0 # デフォルト5。JSが付けたらその値を使う

    @page = params[:page].to_i
    @page = 1 if @page < 1

    @boards = Board
      .includes(user: { avatar_attachment: :blob }, tasks: [:user, { comments: :user }])
      .order(created_at: :desc)
      .offset((@page - 1) * per_page)
      .limit(per_page)

    @total_pages = (Board.count / per_page.to_f).ceil
    @per_page    = per_page # ビューで再利用
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

  def edit
  @board = current_user.boards.find(params[:id])
  end

  def update
    @board = current_user.boards.find(params[:id])
    if @board.update(board_params)
      redirect_to root_path, notice: 'ボードを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:id])
    @tasks = @board.tasks.includes(:user).order(created_at: :desc)
    @task = Task.new
  end

  def destroy
    @board.destroy
    redirect_to root_path, notice: 'ボードを削除しました'
  end

# 外部から直接呼び出せないようにする処理（Strong Parametersの定義）
# フォームで board に関するデータが送られてこないとエラー発生
# title と content のみを許可する
  private
  def board_params
    params.require(:board).permit(:title, :content, :deadline, :eyecatch)
  end

  def set_board
    @board = Board.find(params[:id])
  end

# 作成者だけが編集・削除できるように制限
  def correct_user
    redirect_to root_path, alert: '権限がありません' unless @board.user == current_user
  end

end
