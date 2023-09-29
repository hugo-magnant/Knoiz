module StripeServices
  class BillingPortalService
    # Initialisation de la classe avec l'utilisateur actuel
    def initialize(current_user)
      @current_user = current_user
    end

    # Méthode pour créer une session de portail de facturation avec Stripe
    def create_billing_portal_session
      result = {}  # Hash vide pour stocker les résultats de l'opération
      # Crée une session de portail de facturation Stripe
      session = Stripe::BillingPortal::Session.create({
        customer: @current_user.subscription.stripe_user_id,  # Utilise l'ID utilisateur de Stripe associé à l'utilisateur actuel
        return_url: "#{Rails.application.routes.url_helpers.root_url}/users/manage",  # URL de retour après la session
      })

      result[:redirect_url] = session.url  # Stocke l'URL de la session dans le hash de résultat
      result  # Retourne le hash de résultat
    rescue Stripe::StripeError => e # Gère les erreurs Stripe spécifiques
      Rails.logger.error "StripeError: #{e.message}"  # Log l'erreur dans le journal Rails
      result[:error] = e.message  # Stocke le message d'erreur dans le hash de résultat
      result  # Retourne le hash de résultat avec l'erreur
    end
  end
end
