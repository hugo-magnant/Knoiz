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

    # Si active est à true mais que stripe_user_id est nil,
    # alors mettre active à false, stripe_subscription_id à nil et canceled à false.
    if subscription.active && subscription.stripe_user_id.nil?
      subscription.update(
        active: false,
        stripe_subscription_id: nil,
        canceled: false,
      )
      return
    end

    # Si l'abonnement est actif, alors le service `StripeSubscriptionUpdater` est appelé.
    return unless subscription.active

    # Crée une nouvelle instance de StripeSubscriptionUpdater et appelle sa méthode call pour mettre à jour l'abonnement
    StripeSubscriptionUpdater.new(@current_user).call
  end
end
