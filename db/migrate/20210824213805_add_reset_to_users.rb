class AddResetToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_digest, :string, limit: 191
    add_column :users, :reset_sent_at, :datetime
  end
end
