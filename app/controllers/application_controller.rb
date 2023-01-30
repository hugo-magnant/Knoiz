class ApplicationController < ActionController::Base

    protect_from_forgery

    before_action :set_current_user
    before_action :check_stripe_subscription

    def set_current_user
        if !session[:user_id].nil?
            @current_user = User.find_by(id: session[:user_id])
        end
    end

    def check_stripe_subscription
        if !session[:user_id].nil? and @current_user.subscription.active == true
            subscriptions = Stripe::Subscription.list(customer: @current_user.subscription.stripe_user_id)
            if subscriptions.data.any? { |sub| sub.status == 'active' }
            # User is currently subscribed
            else
                @current_user.subscription.active = false
                @current_user.subscription.stripe_user_id = ""
                @current_user.subscription.stripe_subscription_id = ""
                @current_user.subscription.save
                @current_user.profile.credits = 0
                @current_user.profile.save
            end
        end
    end

end
