class HomeController < ApplicationController
    # トップページ。最新のボードをカードで並べる画面
  def index
    # 1ページに表示する列数（JSで計算して per_page を付与。無ければ 5）
    per_page = params[:per_page].presence&.to_i || 5
    per_page = 5 if per_page <= 0

    # ページ番号（1始まり）
    @page = params[:page].to_i
    @page = 1 if @page < 1

    # 画面で使う関連を“最初にまとめて”取得して N+1 を回避する
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

    # 総ページ数 = 総件数 ÷ 1ページ件数 を切り上げ
    @total_pages = (Board.count / per_page.to_f).ceil
    # ビューでも使うので per_page をインスタンス変数に残す
    @per_page    = per_page
  end
end
