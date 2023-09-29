class StripeSubscriptionUpdater
  # Initialisation avec l'utilisateur concerné
  def initialize(user)
    @user = user
  end

  # Méthode principale pour mettre à jour l'abonnement
  def call
    # Sortir si l'utilisateur ou son abonnement n'est pas défini
    return unless @user&.subscription&.stripe_user_id

    # Récupérer les abonnements de Stripe
    subscriptions = Stripe::Subscription.list(customer: @user.subscription.stripe_user_id)

    # Mettre à jour le statut de l'abonnement en fonction des données de Stripe
    if active_subscription?(subscriptions)
      update_subscription_status(active: true)
    elsif trial_active?(subscriptions)
      update_subscription_status(active: true)
    else
      deactivate_subscription
    end
  rescue Stripe::StripeError => e
    # Gestion des erreurs spécifiques à Stripe
    Rails.logger.error("Erreur Stripe : #{e.message}")
  rescue StandardError => e
    # Gestion des autres erreurs
    Rails.logger.error("Erreur générale : #{e.message}")
  end

  private

  # Vérifie si l'abonnement est actif
  def active_subscription?(subscriptions)
    subscriptions.data.any? { |sub| sub.status == "active" }
  end

  # Vérifie si l'abonnement est en période d'essai
  def trial_active?(subscriptions)
    subscriptions.data.size == 1 &&
      subscriptions.data.first.trial_end &&
      Time.now.to_i < subscriptions.data.first.trial_end
  end

  # Met à jour le statut de l'abonnement dans la base de données
  def update_subscription_status(status)
    @user.subscription.update!(status)
  end

  # Désactive l'abonnement et nettoie les champs correspondants
  def deactivate_subscription
    @user.subscription.update!(
      active: false,
      stripe_subscription_id: "",
      canceled: false,
    )
  end
end
