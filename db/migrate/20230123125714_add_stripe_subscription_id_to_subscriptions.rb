class AddStripeSubscriptionIdToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :stripe_subscription_id, :string
  end
end
