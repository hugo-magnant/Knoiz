class AddDefaultValueToCredits < ActiveRecord::Migration[7.0]
  def change
    change_column_default :wallets, :credits, 1
  end
end
