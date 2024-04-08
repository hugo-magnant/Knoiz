class PaymentsController < ApplicationController
  PRICE_MAPPING = {
    '7' => ENV["STRIPE_PRICE_7"],
    '30' => ENV["STRIPE_PRICE_30"],
    '180' => ENV["STRIPE_PRICE_180"]
  }.freeze

  def create_checkout_session
    stripe_price = PRICE_MAPPING[params[:price]]
    raise "Invalid price" unless stripe_price

    session_params = {
      payment_method_types: ['card'],
      line_items: [{
        price: stripe_price,
        quantity: 1,
      }],
      mode: 'payment',
      success_url: payments_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: payments_cancel_url,
    }

    if @current_user.subscription.stripe_user_id
      session_params[:customer] = @current_user.subscription.stripe_user_id
    end

    @session = Stripe::Checkout::Session.create(session_params)

    redirect_to @session.url, allow_other_host: true
  rescue => e
    puts e.message
  end

  def success
    session_id = params[:session_id]
    @session = Stripe::Checkout::Session.retrieve(session_id)

    line_items = Stripe::Checkout::Session.list_line_items(session_id, {limit: 1})
    price_id = line_items.data.first.price.id

    update_subscription(price_id)

    unless @current_user.subscription.stripe_user_id
      @current_user.subscription.stripe_user_id = @session.customer
      @current_user.subscription.save!
    end

    redirect_to root_path
  rescue => e
    # Handle error, e.g. log it and show an error message to the user
  end

  def cancel
    # Handle payment cancellation
    redirect_to root_path
  end

  private

  def update_subscription(price_id)
    days = case price_id
           when ENV["STRIPE_PRICE_7"]
             7
           when ENV["STRIPE_PRICE_30"]
             30
           when ENV["STRIPE_PRICE_180"]
             180
           else
             # Handle invalid price_id
           end

    @current_user.subscription.expires_at = days.days.from_now.end_of_day
    @current_user.subscription.active = true
    @current_user.subscription.save!
  end
end