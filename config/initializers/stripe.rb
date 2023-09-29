require "stripe"

Stripe.api_key = ENV["STRIPE_KEY"]
StripePrice = ENV.fetch("STRIPE_PRICE")
