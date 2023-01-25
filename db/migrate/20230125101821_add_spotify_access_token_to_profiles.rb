class AddSpotifyAccessTokenToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :spotify_access_token, :string
  end
end
