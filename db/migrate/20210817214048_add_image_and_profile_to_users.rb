class AddImageAndProfileToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :image, :string, limit: 191
  end
end
