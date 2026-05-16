class BoardsController < ApplicationController
  before_action :set_board,      only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @boards = Board
      .includes(
        user: { avatar_attachment: :blob },
        tasks: [:user, { comments: :user }]
      )
      .order(created_at: :desc)
  end

  def new
    @board = Board.new
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to root_path, notice: 'ボードを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      redirect_to root_path, notice: 'ボードを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @tasks = @board.tasks.includes(:user).ordered_by_deadline
    @task  = Task.new
  end

  def destroy
    @board.destroy
    redirect_to root_path, notice: 'ボードを削除しました'
  end

  private

  def board_params
    params.require(:board).permit(:title, :content)
  end

  def set_board
    @board = Board.find(params[:id])
  end

  def authorize_owner!
    redirect_to root_path, alert: '権限がありません' unless @board.user == current_user
  end
end
