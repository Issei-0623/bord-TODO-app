class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  delegate :birthday, :age, :gender, :introduction, to: :profile, allow_nil: true

  has_many :boards, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one_attached :avatar

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def has_written?(task)
    tasks.exists?(id: task.id)
  end

  def prepare_profile
    profile || build_profile
  end

  def display_name
    profile&.nickname || self.email.split('@').first
  end

  def avatar_image
    if profile&.avatar&.attached?
      profile.avatar
    else
      'default-avatar.png'
    end
  end

  def avatar_url(size: [28, 28])
    if avatar&.attached?
      avatar.variant(resize_to_fill: size).processed
    elsif profile&.avatar&.attached?
      profile.avatar.variant(resize_to_fill: size).processed
    else
      'default-avatar.png' # /assets/ は付けない（Propshaft）
    end
  end
end
