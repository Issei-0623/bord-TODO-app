require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
  end

  describe '#age' do
    context '誕生日が設定されている場合' do
      it '正しい年齢を返す' do
        profile = build(:profile, birthday: 30.years.ago.to_date)
        expect(profile.age).to eq 30
      end

      it '今日が誕生日の場合、正しい年齢を返す' do
        profile = build(:profile, birthday: Date.current.change(year: Date.current.year - 25))
        expect(profile.age).to eq 25
      end

      it '今年の誕生日をまだ迎えていない場合、1少ない年齢を返す' do
        birthday = Date.current.next_day.change(year: Date.current.year - 20)
        profile  = build(:profile, birthday: birthday)
        expect(profile.age).to eq 19
      end
    end

    context '誕生日が未設定の場合' do
      it '「不明」を返す' do
        profile = build(:profile, birthday: nil)
        expect(profile.age).to eq '不明'
      end
    end
  end
end
