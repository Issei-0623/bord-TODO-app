class CommentsController < ApplicationController
  # コメントの作成・編集・削除はログイン必須
  before_action :authenticate_user!

  # ネストされた URL (/tasks/:task_id/comments/…) から親タスクを取得
  before_action :set_task

  # 編集・更新・削除で対象コメントを取得
  before_action :set_comment, only: [:edit, :update, :destroy]

  # コメントの作者本人しか編集系を通さない
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  # 新規フォーム表示。親タスクに紐づく空コメントを用意する
  def new
    @comment = @task.comments.build
  end

  # 親タスクに current_user のコメントを 1 件作成
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
    # authorize_owner! は before_action で実行済み
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

  # 親タスクを URL から取得
  def set_task
    @task = Task.find(params[:task_id])
  end

  # 親タスク配下からコメントを取得
  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  # コメント作者かどうかをチェック
  def authorize_owner!
    return if @comment.user == current_user
    redirect_to board_task_path(@task.board, @task), alert: '権限がありません'
  end

  # Strong Parameters：受け付けるのは本文のみ
  def comment_params
    params.require(:comment).permit(:content)
  end
end
