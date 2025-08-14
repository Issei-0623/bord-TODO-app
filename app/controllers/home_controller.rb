class HomeController < ApplicationController
  def index
    # URLパラメータが無ければ5をデフォルトに
    per_page = params[:per_page].presence&.to_i || 5
    per_page = 5 if per_page <= 0

    @page = params[:page].to_i
    @page = 1 if @page < 1

    @latest_boards =
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
        .offset((@page - 1) * per_page)
        .limit(per_page)

    @total_pages = (Board.count / per_page.to_f).ceil
    @per_page    = per_page
  end
end
