class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :spotify_id
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
