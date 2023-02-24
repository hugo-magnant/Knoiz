class CheckoutSessionController < ApplicationController

  before_action :subscription_check, only: [:create]

  def create
    begin
      prices = Stripe::Price.list(expand: ['data.product'])
      session = Stripe::Checkout::Session.create({
        mode: 'subscription',
        line_items: [{
          quantity: 1,
          price: 'price_1MT4RXDY9Oz58rvRI8tp1tGB'
        }],
        success_url: "#{request.base_url}/users/charge?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{request.base_url}/users/info",
      })
      redirect_to session.url, status: 303, allow_other_host: true
    rescue StandardError => e
      payload = { 'error': { message: e.error.message } }
      render :json => payload, :status => :bad_request
    end
  end

  def create_portal_session
    begin
      session = Stripe::BillingPortal::Session.create({
        customer: @current_user.subscription.stripe_user_id,
        return_url: "#{request.base_url}/users/manage"
      })
      redirect_to session.url, status: 303, allow_other_host: true
    rescue StandardError => e
      payload = { 'error': { message: e.error.message } }
      render :json => payload, :status => :bad_request
    end
  end

  private

  def subscription_check
    if !session[:user_id].nil?
      if @current_user.subscription.active == true and @current_user.subscription.canceled == true
        redirect_to info_path, info: "You are already subscribed. To resume your subscription, please click on the 'Resume my subscription' button."
      elsif @current_user.subscription.active == true
          redirect_to pricing_path, info: "You are already subscribed."
      end
    else
      redirect_to pricing_path, alert: "You must be logged in."
    end
    
  end

end