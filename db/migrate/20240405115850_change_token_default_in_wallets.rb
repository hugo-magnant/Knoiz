class ChangeTokenDefaultInWallets < ActiveRecord::Migration[7.0]
    def change
      change_column_default :wallets, :token, '1'
    end
end
