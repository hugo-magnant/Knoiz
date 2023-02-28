class AddDefaultToWalletTimestamp < ActiveRecord::Migration[7.0]
  def change
    change_column :wallets, :timestamp, :datetime, default: Time.new(2023, 1, 1).utc
  end
end
