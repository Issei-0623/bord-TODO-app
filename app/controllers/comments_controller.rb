class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def new
    @comment = @task.comments.build
  end

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to board_task_path(@task.board, @task), notice: 'コメントを追加しました'
    else
      flash.now[:error] = 'コメントの保存に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to board_task_path(@task.board, @task), notice: 'コメントを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    redirect_to board_task_path(@task.board, @task), notice: 'コメントを削除しました。'
  end

  private
  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def authorize_owner!
    return if @comment.user == current_user
    redirect_to board_task_path(@task.board, @task), alert: '権限がありません'
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
