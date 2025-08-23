class ProfilesController < ApplicationController
  # ログイン中の本人だけが閲覧/編集できるページ
  before_action :authenticate_user!

  # 全アクションで @profile を用意
  before_action :set_profile

  # 単数resource :profile を使っているので id は不要
  def show; end

  def edit; end

  # Strong Parameters で許可した項目だけを更新
  # 成功→画面遷移＋notice、失敗→同画面を再表示してエラーを見せる
  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました！'
    else
      # render のときは flash.now を使う（redirect ではないため）
      flash.now[:error] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  private
  # 現在ユーザーのプロフィールを取得
  # まだ無ければ build_profile で「未保存の新規インスタンス」を用意。
  def set_profile
    @profile = current_user.profile || current_user.build_profile
  end

  # Strong Parameters:
  def profile_params
    params.require(:profile).permit(
      :nickname, :introduction, :gender, :birthday, :subscribed, :avatar
    )
  end
end
