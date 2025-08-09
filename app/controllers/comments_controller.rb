class CommentsController < ApplicationController
  def new
    task = Task.find(params[:task_id])
    @comment = task.comments.build
  end

  def create
    @task = Task.find(params[:task_id])
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to board_task_path(@task.board, @task), notice: 'コメントを追加しました'
    else
      flash.now[:error] = 'コメントの保存に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end