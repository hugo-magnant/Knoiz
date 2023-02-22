class AddDefaultTimestampToSpotifydata < ActiveRecord::Migration[7.0]
  def change
    change_column :spotifydata, :timestamp, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
