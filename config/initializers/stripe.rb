require 'stripe'
require_relative '../../.stripe_key.rb'

Stripe.api_key = "#{$stripe_key}"