class AddTimestampToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :timestamp, :datetime
  end
end
