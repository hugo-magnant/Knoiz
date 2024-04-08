module StripeSubscriptionConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_stripe_subscription
  end

  private

  # Vérifie l'état de l'abonnement Stripe pour l'utilisateur actuel
  def check_stripe_subscription
    # Récupère l'objet d'abonnement associé à l'utilisateur courant
    subscription = @current_user&.subscription
    # Si l'objet d'abonnement est nil, quitte la méthode
    return unless subscription

    # Vérifie si l'abonnement est actif
    if subscription.active?
      # Vérifie si l'abonnement a expiré
      if subscription.expires_at && subscription.expires_at < Time.current
        subscription.update(active: false, expires_at: nil)
        subscription.save
      end
    end

  end
end
