class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :content
      t.date :deadline
      t.references :user, null: false, foreign_key: true  # 投稿者
      t.references :board, null: false, foreign_key: true # 紐づくボード
      t.timestamps
    end
  end
end


