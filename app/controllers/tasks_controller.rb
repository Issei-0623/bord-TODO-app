class TasksController < ApplicationController
  # すべてのタスク操作はログイン必須にする想定
  before_action :authenticate_user!

  # ネストされた URL (/boards/:board_id/…) から親ボードを先に取得
  before_action :set_board

  # 個別タスクが必要なアクションでは事前に取得
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # 作成者本人しか編集・更新・削除できないようガード
  before_action :authorize_owner!, only: [:edit, :update]

  # 親ボード配下に current_user のタスクを作成
  def create
    @task = @board.tasks.build(task_params)
    @task.user = current_user

    if @task.save
      redirect_to board_path(@board), notice: 'タスクを追加しました'
    else
      # 失敗時は boards/show を再描画するため、一覧も用意（N+1回避のため includes）
      @tasks = @board.tasks.includes(:user)
      render 'boards/show', status: :unprocessable_entity
    end
  end

  # タスク詳細とコメント一覧を表示
  def show
    # コメントで comment.user を表示するので user を先読みして N+1 を回避
    @comments = @task.comments.includes(:user).order(created_at: :asc)
  end

  def edit
    # authorize_owner! は before_action で実行済み
  end

  def update
    if @task.update(task_params)
      redirect_to board_task_path(@board, @task), notice: '更新できました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
    redirect_to board_path(@board), notice: '削除に成功しました'
  end

  private

  # 親ボードを URL から取得
  def set_board
    @board = Board.find(params[:board_id])
  end

  # 親ボード配下から当該タスクを取得
  def set_task
    @task = @board.tasks.find(params[:id])
  end

  # タスク作成者本人かどうかを検証
  def authorize_owner!
    return if @task.user == current_user
    redirect_to board_task_path(@board, @task), alert: '権限がありません'
  end

  # Strong Parameters
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :eyecatch, :priority)
  end
end
