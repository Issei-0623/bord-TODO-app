class BoardsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_board,    only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    per_page = params[:per_page].presence&.to_i
    per_page = Board.count if per_page.nil? || per_page <= 0

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
    @board = Board.find(params[:id])
    @tasks = @board.tasks.includes(:user).order(Arel.sql("CASE WHEN deadline IS NULL THEN 1 ELSE 0 END, deadline ASC"))
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

  def correct_user
    redirect_to root_path, alert: '権限がありません' unless @board.user == current_user
  end
end
