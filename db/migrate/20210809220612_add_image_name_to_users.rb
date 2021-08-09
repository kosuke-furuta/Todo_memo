class AddImageNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :images_name, :string
  end
end
