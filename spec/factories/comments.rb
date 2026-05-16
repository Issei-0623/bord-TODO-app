FactoryBot.define do
  factory :comment do
    association :user
    association :task
    content { 'コメントの内容です' }
  end
end
