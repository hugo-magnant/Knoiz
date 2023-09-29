module StripeServices
  class SubscriptionCheckService
    # Initialisation avec l'utilisateur actuel et l'ID utilisateur de la session
    def initialize(current_user, session_user_id)
      @current_user = current_user
      @session_user_id = session_user_id
    end

    # Méthode principale pour effectuer la vérification
    def call
      result = {}  # Initialise un hash vide pour stocker les résultats

      # Vérifie si l'ID utilisateur de la session est nil
      if @session_user_id.nil?
        result[:redirect_path] = Rails.application.routes.url_helpers.root_path
        result[:alert] = "You must be logged in."  # Définit un message d'alerte

        # Vérifie si l'abonnement de l'utilisateur est actif
      elsif @current_user.subscription.active?

        # Détermine le message à afficher en fonction de l'état de l'abonnement
        message = @current_user.subscription.canceled? ?
          I18n.t("flash_messages.subscription.resume_subscription") :
          I18n.t("flash_messages.subscription.already_subscribed")

        result[:info] = message  # Stocke le message dans le hash de résultat

        # Définit le chemin de redirection en fonction de l'état de l'abonnement
        result[:redirect_path] = @current_user.subscription.canceled? ? info_path : pricing_path
      end

      result  # Retourne le hash de résultat
    end
  end
end
