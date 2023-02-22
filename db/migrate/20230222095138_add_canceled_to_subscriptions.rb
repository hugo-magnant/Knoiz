class AddCanceledToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :canceled, :boolean, default: false
  end
end
