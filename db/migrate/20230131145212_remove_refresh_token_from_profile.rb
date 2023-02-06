class RemoveRefreshTokenFromProfile < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :refresh_token, :string
  end
end
