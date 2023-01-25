class ApplicationController < ActionController::Base

    before_action :check_subscription

    private

    def check_subscription
        if user_signed_in? and current_user.subscription.active == true
            subscriptions = Stripe::Subscription.list(customer: current_user.subscription.stripe_user_id)
            if subscriptions.data.any? { |sub| sub.status == 'active' }
            # User is currently subscribed
            else
                current_user.subscription.active = false
                current_user.subscription.stripe_user_id = ""
                current_user.subscription.stripe_subscription_id = ""
                current_user.subscription.save
                current_user.profile.credits = 0
                current_user.profile.save
            end
        end
    end

end
