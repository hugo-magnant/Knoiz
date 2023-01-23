class SubscriptionsController < ApplicationController
  
  def new
    session = Stripe::Checkout::Session.create({
      success_url: root_url,
      cancel_url: new_subscription_url,
      line_items: [
        {price: 'price_1MT4RXDY9Oz58rvRI8tp1tGB', quantity: 1},
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
    current_user.subscription.update(subscription_id: subscription.id, subscription_status: "active")
    redirect_to subscriptions_success_path
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to pricing_path
  end

  def update
  end

  def cancel
  end

end
