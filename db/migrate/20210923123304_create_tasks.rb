class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name, limit:30
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :tasks, [:user_id, :created_at, :updated_at]
  end
end
