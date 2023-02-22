class CreateSpotifydata < ActiveRecord::Migration[7.0]
  def change
    create_table :spotifydata do |t|
      t.jsonb :favorite_genre

      t.timestamps
    end
  end
end
