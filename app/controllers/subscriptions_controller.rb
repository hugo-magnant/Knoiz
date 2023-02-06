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
    @current_user.subscription.update(subscription_id: subscription.id, subscription_status: "active")
    redirect_to subscriptions_success_path
  rescue Stripe::StripeError => e
    flash[:error] = e.message
    redirect_to pricing_path
  end

  def update
  end

  def cancel
    subscription = Stripe::Subscription.retrieve(@current_user.subscription.stripe_subscription_id)
    subscription.cancel



      @subscription_info = {
        ends_on: subscription.canceled_at.present? ? Time.at(subscription.canceled_at).strftime("%Y-%m-%d") : Time.at(subscription.current_period_end).strftime("%Y-%m-%d")
      }

    redirect_to root_path, notice: "Spotilab.ai premium annulé avec succès, vous concervez votre accès jusqu'au #{@subscription_info[:ends_on]}!"
    rescue Stripe::StripeError => e
      redirect_to info_path, alert: "erreur"
  end

end
