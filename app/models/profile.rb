class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  enum :gender, { male: 0, female: 1, other: 2 }


  # 年齢（生年月日未設定なら "不明"）
  def age
    return '不明' unless birthday.present?
    today = Date.current
    years = today.year - birthday.year
    years -= 1 if today.yday < birthday.yday
    years
  end

  include Rails.application.routes.url_helpers

  def avatar_url
    if avatar.attached?
      rails_blob_url(avatar, host: Rails.application.routes.default_url_options[:host])
    elsif user.respond_to?(:avatar_url) && user.avatar_url.present?
      user.avatar_url
    else
      ActionController::Base.helpers.asset_path('default-avatar.png')
    end
  end

end
