# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  content    :text
#  deadline   :date
#  user_id    :integer          not null
#  board_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  priority   :string
#
# Indexes
#
#  index_tasks_on_board_id  (board_id)
#  index_tasks_on_user_id   (user_id)
#

class Task < ApplicationRecord
  belongs_to :user
  belongs_to :board

  has_many :comments, dependent: :destroy

  has_one_attached :eyecatch

  scope :ordered_by_deadline, -> {
    order(Arel.sql("CASE WHEN deadline IS NULL THEN 1 ELSE 0 END, deadline ASC"))
  }

  validates :title,    presence: true
  validates :content,  presence: true
  validates :priority, inclusion: { in: %w[high medium low], allow_blank: true }
end
