class BoardsController < ApplicationController
  # ログインが必要なのは作成・編集・更新・削除のみ
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  # 編集・更新・削除の直前で対象レコードを取得
  before_action :set_board,    only: [:edit, :update, :destroy]
  # 作成者本人だけが編集・削除できるように制御
  before_action :correct_user, only: [:edit, :update, :destroy]

  # --- 一覧 ---
  # ページング＋N+1回避のための includes を使う版だけを残す
  # - per_page: 1ページあたり表示件数（画面幅に応じてJSが上書き）
  # - @page: 現在ページ（1始まり）
  # - includes: Board作者(User)とそのアバター、Task と Task作者/コメントを先読み
  def index
    per_page = params[:per_page].presence&.to_i
    per_page = 5 if per_page.nil? || per_page <= 0 # デフォルト 5

    @page = params[:page].to_i
    @page = 1 if @page < 1

    @boards = Board
      .includes(
        user: { avatar_attachment: :blob },
        tasks: [:user, { comments: :user }]
      )
      .order(created_at: :desc)
      .offset((@page - 1) * per_page)
      .limit(per_page)

    @total_pages = (Board.count / per_page.to_f).ceil
    @per_page    = per_page
  end

  # --- 新規作成フォーム ---
  # 空のインスタンスを渡すだけ（form_with のモデルに使う）
  def new
    @board = Board.new
  end

  # --- 作成 ---
  # current_user 配下でレコード作成
  # 成功: トップへリダイレクト＋フラッシュ
  # 失敗: new を再表示（422）
  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to root_path, notice: 'ボードを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # --- 編集フォーム ---
  # set_board 済み。本人チェックは correct_user で済むのでここでは何もしない
  def edit
  end

  # --- 更新 ---
  # set_board + correct_user 済み。成功/失敗で分岐
  def update
    if @board.update(board_params)
      redirect_to root_path, notice: 'ボードを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # --- 詳細 ---
  # 一覧とは別に、単一ボードのタスク一覧を表示
  def show
    @board = Board.find(params[:id])
    # タスク作者情報も一緒に読み込んで N+1 を抑える
    @tasks = @board.tasks.includes(:user).order(created_at: :desc)
    @task  = Task.new # boards/show 内の「タスク追加フォーム」用
  end

  # --- 削除 ---
  def destroy
    @board.destroy
    redirect_to root_path, notice: 'ボードを削除しました'
  end

  private

  # Strong Parameters:
  # - title, content: フォームの基本項目
  def board_params
    params.require(:board).permit(:title, :content)
  end

  # URL の :id から対象ボードを取得
  def set_board
    @board = Board.find(params[:id])
  end

  # 作成者だけ許可（他人のボードには編集・削除で入れない）
  def correct_user
    redirect_to root_path, alert: '権限がありません' unless @board.user == current_user
  end
end
