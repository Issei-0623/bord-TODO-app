require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'アソシエーション' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:board) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }

    context '正常な値の場合' do
      it '保存できる' do
        task = build(:task)
        expect(task).to be_valid
      end
    end

    context 'タイトルが空の場合' do
      it '保存できない' do
        task = build(:task, title: '')
        expect(task).not_to be_valid
      end
    end

    context '内容が空の場合' do
      it '保存できない' do
        task = build(:task, content: '')
        expect(task).not_to be_valid
      end
    end

    context 'priorityの値が正しい場合' do
      %w[high medium low].each do |priority|
        it "#{priority} は保存できる" do
          task = build(:task, priority: priority)
          expect(task).to be_valid
        end
      end
    end

    context 'priorityが不正な値の場合' do
      it '保存できない' do
        task = build(:task, priority: 'urgent')
        expect(task).not_to be_valid
      end
    end

    context 'priorityが空（未設定）の場合' do
      it '保存できる' do
        task = build(:task, priority: '')
        expect(task).to be_valid
      end
    end
  end

  describe '.ordered_by_deadline スコープ' do
    it '期限あり → 期限なし の順に並ぶ' do
      user  = create(:user)
      board = create(:board, user: user)
      no_deadline = create(:task, user: user, board: board, deadline: nil)
      later   = create(:task, user: user, board: board, deadline: Date.current + 10)
      earlier = create(:task, user: user, board: board, deadline: Date.current + 1)

      expect(Task.ordered_by_deadline).to eq [earlier, later, no_deadline]
    end
  end
end
