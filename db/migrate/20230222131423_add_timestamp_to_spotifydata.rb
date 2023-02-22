class AddTimestampToSpotifydata < ActiveRecord::Migration[7.0]
  def change
    add_column :spotifydata, :timestamp, :datetime
  end
end
