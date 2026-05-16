class HomeController < ApplicationController
  def index
    setup_pagination(default_per_page: 5)

    @latest_boards = paginate(
      Board
        .includes(
          user:  [ avatar_attachment: :blob ],
          tasks: [
            :user,
            { comments: :user },
            { eyecatch_attachment: :blob },
            { user: [ avatar_attachment: :blob ] }
          ]
        )
        .order(created_at: :desc)
    )
  end
end
