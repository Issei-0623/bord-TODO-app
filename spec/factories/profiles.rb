FactoryBot.define do
  factory :profile do
    association :user
    nickname { 'テストユーザー' }
    introduction { '自己紹介文です' }
    gender { :male }
    birthday { Date.new(1990, 6, 15) }
  end
end
