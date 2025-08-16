class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_board
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # POST /boards/:board_id/tasks
  def create
    @task = @board.tasks.build(task_params)
    @task.user = current_user
    if @task.save
      redirect_to board_path(@board), notice: 'タスクを追加しました'
    else
      @tasks = @board.tasks.includes(:user)
      render 'boards/show', status: :unprocessable_entity
    end
  end

  # GET /boards/:board_id/tasks/:id
  def show
    @board = Board.find(params[:board_id])
    @task  = @board.tasks.find(params[:id])
    @comments = @task.comments.order(created_at: :asc) 
  end

  # GET /boards/:board_id/tasks/:id/edit
  def edit
    authorize_owner!
  end

  # PUT /boards/:board_id/tasks/:id
  def update
    authorize_owner!
    if @task.update(task_params)
      redirect_to board_task_path(@board, @task), notice: '更新できました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /boards/:board_id/tasks/:id
  def destroy
    authorize_owner!
    @task.destroy!
    redirect_to board_path(@board), notice: '削除に成功しました'
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_task
    @task = @board.tasks.find(params[:id])
  end

  def authorize_owner!
    redirect_to board_task_path(@board, @task), alert: '権限がありません' unless @task.user == current_user
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline, :eyecatch)
  end
end
