class ChangeExpiresAtDefaultInSubscriptions < ActiveRecord::Migration[7.0]
  def change
    change_column_default :subscriptions, :expires_at, nil
  end
end
