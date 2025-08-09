class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar
  enum :gender, { male: 0, female: 1, other: 2 }


    def age
      return '不明' unless birthday.present?
      today = Time.zone.today
      age = today.year - birthday.year
      age -= 1 if today.yday < birthday.yday
      "#{age}歳"
  end
end
