class HomeController < ApplicationController
  def index
    @latest_boards =
  Board
    .includes(
      user:  [ avatar_attachment: :blob ],
      tasks: [
        :comments,
        :user,                    # タスク投稿者
        { eyecatch_attachment: :blob },         # タスクの画像があるなら
        { user: [ avatar_attachment: :blob ] }  # タスク投稿者のアバター
      ]
    )
    .order(created_at: :desc)
    .limit(3)
  end
end