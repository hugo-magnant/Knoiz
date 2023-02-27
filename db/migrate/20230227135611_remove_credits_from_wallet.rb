class RemoveCreditsFromWallet < ActiveRecord::Migration[7.0]
  def change
    remove_column :wallets, :credits, :integer
  end
end
