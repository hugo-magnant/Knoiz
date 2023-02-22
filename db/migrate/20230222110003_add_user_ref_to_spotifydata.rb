class AddUserRefToSpotifydata < ActiveRecord::Migration[7.0]
  def change
    add_reference :spotifydata, :user, null: false, foreign_key: true
  end
end
