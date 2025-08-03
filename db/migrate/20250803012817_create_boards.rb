class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.references :user, null: false, foreign_key: true # ユーザーとの関連付け
      t.string :title, null: false                       # タイトル
      t.text :content, null: false                      # ボードの概要
      t.timestamps
    end
  end
end
