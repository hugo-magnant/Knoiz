class SubscriptionsController < ApplicationController
  
  def new
    session = Stripe::Checkout::Session.create({
      success_url: root_url,
      cancel_url: new_subscription_url,
      line_items: [
        {price: 'price_1MoUcjDY9Oz58rvRDVS53Wiu', quantity: 1},
      ],
      mode: 'subscription',
    })
    @session_id = session.id
  end

  def create
    session_id = params[:session_id]
    session = Stripe::Checkout::Session.retrieve(session_id)
    customer_id = session.customer
    subscription = Stripe::Subscription.create({
      customer: customer_id,
      items: [{plan: 'premium_plan'}],
    })
    @current_user.subscription.update(stripe_user_id: customer_id, stripe_subscription_id: subscription.id, active: true, canceled: false)
    redirect_to subscriptions_success_path
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to pricing_path
  end

  def resume
    subscription = Stripe::Subscription.retrieve(@current_user.subscription.stripe_subscription_id)
    subscription.cancel_at_period_end = false
    subscription.save
    @current_user.subscription.update(canceled: false)
    redirect_to root_path, notice: "Votre abonnement sera renouvelé."
  end

  def cancel
    subscription = Stripe::Subscription.retrieve(@current_user.subscription.stripe_subscription_id)
    subscription.cancel_at_period_end = true
    subscription.save
    @current_user.subscription.update(canceled: true)
    redirect_to root_path, notice: "Votre abonnement a été annulé."
  end

end
