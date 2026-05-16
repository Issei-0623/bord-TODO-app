FactoryBot.define do
  factory :task do
    association :user
    association :board
    sequence(:title) { |n| "タスク#{n}" }
    content { 'タスクの内容です' }
    deadline { Date.current + 7 }
    priority { 'medium' }
  end
end
