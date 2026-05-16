FactoryBot.define do
  factory :board do
    association :user
    sequence(:title) { |n| "ボード#{n}" }
    content { 'ボードの説明文です' }
  end
end
