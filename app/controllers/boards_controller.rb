class BoardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @latest_boards = Board.order(created_at: :desc).limit(3)
  end

  def new
    @boards = current_user.boards.build
  end

 # 特定のボードの詳細を表示
  def show
    @board = Board.find(params[:id])
  end

  def create
    @boards = current_user.boards.build(board_params)
    if @boards.save
      redirect_to board_path(@boards), notice: '保存できたよ'
    else
      flash.now[:error] = '保存に失敗しました'
      render :new
    end
  end

end