class AddTokenToWallets < ActiveRecord::Migration[7.0]
  def change
    add_column :wallets, :token, :string
  end
end
