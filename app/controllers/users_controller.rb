class UsersController < ApplicationController
  before_action :ensure_current_user_and_subscription

  # Affiche les informations d'abonnement de l'utilisateur courant
  def info
    @subscription_info = {
      active: @subscription.active,
      expires_at: @subscription.expires_at
    }
  end

  private

  # Vérifie si l'utilisateur courant et son abonnement existent
  def ensure_current_user_and_subscription
    unless @current_user && @current_user.subscription
      redirect_to root_path, alert: "User or subscription not found."
    else
      @subscription = @current_user.subscription
    end
  end
end
