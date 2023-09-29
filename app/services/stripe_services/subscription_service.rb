module StripeServices
  class SubscriptionService
    # Initialisation avec l'utilisateur actuel et le prix Stripe
    def initialize(current_user, stripe_price)
      @current_user = current_user
      @stripe_price = stripe_price
    end

    # Méthode pour créer un abonnement
    def create_subscription
      result = {}  # Hash pour stocker le résultat

      # Paramètres pour la session Stripe Checkout
      session_params = {
        mode: "subscription",
        line_items: [{
          quantity: 1,
          price: @stripe_price,
        }],
        success_url: "#{Rails.application.routes.url_helpers.root_url}/users/charge?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: "#{Rails.application.routes.url_helpers.root_url}/users/info",
      }

      # Ajoute l'ID utilisateur Stripe s'il est présent
      if @current_user.subscription.stripe_user_id.presence
        session_params[:customer] = @current_user.subscription.stripe_user_id.presence
      end

      # Crée la session Stripe Checkout
      session = Stripe::Checkout::Session.create(session_params)

      # Stocke l'URL de redirection dans le résultat
      result[:redirect_url] = session.url
      result  # Retourne le résultat
    rescue Stripe::StripeError => e # Capture les erreurs Stripe
      Rails.logger.error "StripeError: #{e.message}"
      result[:error] = e.message
      result  # Retourne le résultat avec l'erreur
    end
  end
end
