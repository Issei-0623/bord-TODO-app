require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to have_many(:boards).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_one(:profile).dependent(:destroy) }
  end

  describe '#display_name' do
    context 'ニックネームが設定されている場合' do
      it 'ニックネームを返す' do
        user = create(:user)
        create(:profile, user: user, nickname: 'テストニックネーム')
        expect(user.display_name).to eq 'テストニックネーム'
      end
    end

    context 'ニックネームが未設定の場合' do
      it 'メールアドレスの@より前を返す' do
        user = create(:user, email: 'hello@example.com')
        create(:profile, user: user, nickname: nil)
        expect(user.display_name).to eq 'hello'
      end
    end

    context 'プロフィールが存在しない場合' do
      it 'メールアドレスの@より前を返す' do
        user = create(:user, email: 'hello@example.com')
        expect(user.display_name).to eq 'hello'
      end
    end
  end
end
