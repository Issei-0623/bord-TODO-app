class HomeController < ApplicationController
  def index
    @latest_boards =
      Board
        .includes(user: { avatar_attachment: :blob })
        .order(created_at: :desc)
        .limit(3)
  end
end