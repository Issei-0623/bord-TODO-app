class HomeController < ApplicationController
  def index
    @latest_boards = Board.order(created_at: :desc).limit(3)
  end
end