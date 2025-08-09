class TasksController < ApplicationController
  before_action :authenticate_user!


  def create
    @board = Board.find(params[:board_id])
    @task = @board.tasks.build(task_params)
    @task.user = current_user  # 投稿者を紐づける

    if @task.save
      redirect_to board_path(@board), notice: 'タスクを追加しました'
    else
      @tasks = @board.tasks.includes(:user)
      render 'boards/show', status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:board_id])  # ネストされたルーティングではこちら
    @task = @board.tasks.find(params[:id])  # このタスクだけ表示
  end


  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :eyecatch)
  end
end