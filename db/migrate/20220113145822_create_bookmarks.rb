class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, foreign_key: true
      t.references :task, foreign_key: true

      t.timestamps
      t.index [:user_id, :task_id], unique: true
    end
  end
end
