require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:content) }

    context '正常な値の場合' do
      it '保存できる' do
        comment = build(:comment)
        expect(comment).to be_valid
      end
    end

    context '内容が空の場合' do
      it '保存できない' do
        comment = build(:comment, content: '')
        expect(comment).not_to be_valid
      end
    end
  end
end
