class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, limit: 191
      t.string :email, limit: 191

      t.timestamps
    end
  end
end
