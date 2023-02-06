class CreateWallet < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :timestamp
      t.integer :credits

      t.timestamps
    end
  end
end
