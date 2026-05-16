class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  enum :gender, { male: 0, female: 1, other: 2 }

  def age
    return '不明' unless birthday.present?
    today = Date.current
    years = today.year - birthday.year
    years -= 1 if today < birthday.change(year: today.year)
    years
  end
end
