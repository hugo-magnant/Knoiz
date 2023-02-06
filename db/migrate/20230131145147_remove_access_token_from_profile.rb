class RemoveAccessTokenFromProfile < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :access_token, :string
  end
end
