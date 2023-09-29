class CheckoutSessionController < ApplicationController
  before_action :subscription_check, only: [:create]

  # Méthode pour créer une nouvelle session de paiement avec Stripe
  def create
    # Initialise le service de souscription avec les paramètres de l'utilisateur courant et des prix Stripe
    service = StripeServices::SubscriptionService.new(@current_user, StripePrice)
    # Appelle la méthode pour créer une souscription et stocke le résultat
    result = service.create_subscription

    # Redirige selon le succès ou l'échec de la création de la souscription
    if result[:error]
      redirect_to root_path, alert: result[:error]
    else
      redirect_to result[:redirect_url], status: 303, allow_other_host: true
    end
  end

  # Méthode pour créer une nouvelle session de portail de facturation avec Stripe
  def create_portal_session
    # Initialise le service de portail de facturation
    service = StripeServices::BillingPortalService.new(@current_user)
    # Crée une nouvelle session de portail de facturation et stocke le résultat
    result = service.create_billing_portal_session

    # Redirige selon le succès ou l'échec de la création de la session de portail de facturation
    if result[:error]
      redirect_to root_path, alert: result[:error]
    else
      redirect_to result[:redirect_url], status: 303, allow_other_host: true
    end
  end

  private

  # Méthode privée pour vérifier l'état de l'abonnement avant de créer une nouvelle session de paiement
  def subscription_check
    # Appelle un service pour vérifier l'état de l'abonnement
    result = StripeServices::SubscriptionCheckService.new(@current_user, session[:user_id]).call

    # Redirige l'utilisateur selon le résultat de la vérification
    if result[:redirect_path]
      redirect_to result[:redirect_path], alert: result[:alert], flash: { info: result[:info] }
    end
  end
end
