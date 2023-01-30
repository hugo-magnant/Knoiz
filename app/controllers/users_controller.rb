class UsersController < ApplicationController

  def create 

  end

  def info
    @subscription = @current_user.subscription
    if @subscription.stripe_subscription_id.present?
      ss = Stripe::Subscription.retrieve(@subscription.stripe_subscription_id)
      stripe_product = Stripe::Product.retrieve(ss.items.data.first.plan.product)
      @product = {
        name: stripe_product.name,
        description: stripe_product.description
      }
      @subscription_info = {
        renews_on: Time.at(ss.current_period_end).strftime("%Y-%m-%d"),
        canceled_at: ss.canceled_at.present? ? Time.at(ss.canceled_at).strftime("%Y-%m-%d") : nil
      }
    end
  end

  def charge
    stripe_session_id = params[:session_id]
    if stripe_session_id
      puts "Redirected here from Stripe subscription signup: #{stripe_session_id}"
      stripe_session = Stripe::Checkout::Session.retrieve(stripe_session_id)
      @current_user.subscription.update(
        stripe_user_id: stripe_session.customer,
        stripe_subscription_id: stripe_session.subscription,
        active: true
      )
      @current_user.profile.credits = 10000
      @current_user.profile.save
      redirect_to root_path, notice: "Subscription to Djai.app premium successful!"
    end
  end

  def manage
    @subscription = @current_user.subscription
    ss = Stripe::Subscription.retrieve(@subscription.stripe_subscription_id)
    if ss.canceled_at.present?
      # at some point need to set subscription to inactive but only at period end, either webhooks or background processing/cron?
      # current_user.subscription.update(active: false)
      redirect_to :users_info, notice: "Request to cancel subscription received"
    else
      redirect_to :users_info
    end
  end

end