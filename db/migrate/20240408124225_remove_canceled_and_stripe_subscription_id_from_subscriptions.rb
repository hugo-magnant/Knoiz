class RemoveCanceledAndStripeSubscriptionIdFromSubscriptions < ActiveRecord::Migration[7.0]
  def change
    remove_column :subscriptions, :canceled
    remove_column :subscriptions, :stripe_subscription_id
  end
end
