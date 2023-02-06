class RemoveSpotifyAccessTokenFromProfile < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :spotify_access_token, :string
  end
end
