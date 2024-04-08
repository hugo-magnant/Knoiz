class AddExpiresAtToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :expires_at, :datetime
  end
end
