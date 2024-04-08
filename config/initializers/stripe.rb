require "stripe"

Stripe.api_key = ENV["STRIPE_KEY"]
StripePrice7 = ENV.fetch("STRIPE_PRICE_7")
StripePrice30 = ENV.fetch("STRIPE_PRICE_30")
StripePrice180 = ENV.fetch("STRIPE_PRICE_180")
