class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username
      t.integer :credits, default: 1

      t.timestamps
    end
  end
end
