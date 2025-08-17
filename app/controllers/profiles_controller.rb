class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile

  def show; end
  def edit; end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: 'プロフィールを更新しました！'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    # プロフィールが無ければ作成して編集できるようにする
    @profile = current_user.profile || current_user.build_profile
  end

  def profile_params
    params.require(:profile).permit(
      :nickname, :introduction, :gender, :birthday, :subscribed, :avatar
    )
  end
end
