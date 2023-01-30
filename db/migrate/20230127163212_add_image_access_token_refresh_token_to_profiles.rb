class AddImageAccessTokenRefreshTokenToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :image, :string
    add_column :profiles, :access_token, :string
    add_column :profiles, :refresh_token, :string
  end
end
