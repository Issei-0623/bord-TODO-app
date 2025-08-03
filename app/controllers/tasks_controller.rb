class TasksController < ApplicationController
  before_action :authenticate_user!

  def create
    @board = Board.find(params[:board_id])
    @task = current_user.tasks.build(task_params)
    @task.board = @board

    if @task.save
      redirect_to board_path(@board), notice: 'タスクを作成しました'
    else
      redirect_to board_path(@board), alert: 'タスクの作成に失敗しました'
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :deadline)
  end
end