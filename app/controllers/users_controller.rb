class UsersController < ApplicationController
  before_action :ensure_current_user_and_subscription, only: [:info, :charge]

  # Affiche les informations d'abonnement de l'utilisateur courant
  def info
    return unless @subscription.stripe_subscription_id.present?
    retrieve_stripe_data
  end

  # Gère le paiement via Stripe
  def charge
    stripe_session_id = params[:session_id]
    return unless stripe_session_id
    handle_stripe_charge(stripe_session_id)
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

  # Récupère et formate les données de l'abonnement Stripe
  def retrieve_stripe_data
    ss = Stripe::Subscription.retrieve(@subscription.stripe_subscription_id)
    stripe_product = Stripe::Product.retrieve(ss.items.data.first.plan.product)
    @product = {
      name: stripe_product.name,
      description: stripe_product.description,
    }
    @subscription_info = {
      renews_on: format_time(ss.current_period_end),
      canceled_at: ss.canceled_at.present? ? format_time(ss.canceled_at) : nil,
      ends_on: ss.canceled_at.present? ? format_time(ss.canceled_at) : format_time(ss.current_period_end),
    }
  end

  # Traite la session de paiement Stripe et met à jour l'abonnement de l'utilisateur
  def handle_stripe_charge(stripe_session_id)
    stripe_session = Stripe::Checkout::Session.retrieve(stripe_session_id)
    @current_user.subscription.update(
      stripe_user_id: stripe_session.customer,
      stripe_subscription_id: stripe_session.subscription,
      active: true,
      canceled: false,
    )
    redirect_to root_path, notice: "Subscription to Knoiz Plus successful !"
  end

  # Formate un temps epoch en chaîne de caractères
  def format_time(epoch_time)
    Time.at(epoch_time).strftime("%Y-%m-%d")
  end
end
