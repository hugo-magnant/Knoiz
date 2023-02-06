class RemoveCreditsFromProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :credits
  end
end
