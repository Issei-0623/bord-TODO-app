require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }

    context '正常な値の場合' do
      it '保存できる' do
        board = build(:board)
        expect(board).to be_valid
      end
    end

    context 'タイトルが空の場合' do
      it '保存できない' do
        board = build(:board, title: '')
        expect(board).not_to be_valid
      end
    end

    context '内容が空の場合' do
      it '保存できない' do
        board = build(:board, content: '')
        expect(board).not_to be_valid
      end
    end
  end
end
