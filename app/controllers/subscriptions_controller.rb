class SubscriptionsController < ApplicationController

  # Méthode pour créer une nouvelle souscription
  def new
    session = create_stripe_session
    @session_id = session.id
  end

  # Méthode pour créer une souscription dans Stripe et mettre à jour l'utilisateur
  def create
    session = retrieve_stripe_session
    customer_id = session.customer
    subscription = create_stripe_subscription(customer_id)

    update_user_subscription(customer_id, subscription.id)

    redirect_to subscriptions_success_path
  rescue Stripe::StripeError => e
    handle_stripe_error(e)
  end

  # Méthode pour reprendre une souscription annulée
  def resume
    subscription = retrieve_stripe_subscription
    resume_stripe_subscription(subscription)

    @current_user.subscription.update(canceled: false)
    redirect_to root_path, notice: "Your subscription will be renewed."
  end

  # Méthode pour annuler une souscription
  def cancel
    subscription = retrieve_stripe_subscription
    cancel_stripe_subscription(subscription)

    @current_user.subscription.update(canceled: true)
    redirect_to root_path, notice: "Your subscription has been canceled."
  end

  private

  # Crée une nouvelle session de paiement Stripe avec le mode d'abonnement
  # Redirige vers 'root_url' si succès et 'new_subscription_url' si annulation
  def create_stripe_session
    Stripe::Checkout::Session.create(
      success_url: root_url,
      cancel_url: new_subscription_url,
      line_items: [{ price: ENV["STRIPE_PRICE"], quantity: 1 }],
      mode: "subscription",
    )
  end

  # Récupère une session Stripe existante à l'aide de l'ID de session passé en paramètre
  def retrieve_stripe_session
    session_id = params[:session_id]
    Stripe::Checkout::Session.retrieve(session_id)
  end

  # Crée une nouvelle souscription Stripe pour un client donné
  # Utilise le plan "premium_plan" pour la souscription
  def create_stripe_subscription(customer_id)
    Stripe::Subscription.create(
      customer: customer_id,
      items: [{ plan: "premium_plan" }],
    )
  end

  # Met à jour la souscription de l'utilisateur courant dans la base de données
  def update_user_subscription(customer_id, subscription_id)
    @current_user.subscription.update(
      stripe_user_id: customer_id,
      stripe_subscription_id: subscription_id,
      active: true,
      canceled: false,
    )
  end

  # Gère les erreurs Stripe et redirige vers la page des tarifs avec un message d'erreur
  def handle_stripe_error(e)
    flash[:error] = e.message
    redirect_to pricing_path
  end

  # Récupère la souscription Stripe de l'utilisateur courant
  def retrieve_stripe_subscription
    Stripe::Subscription.retrieve(@current_user.subscription.stripe_subscription_id)
  end

  # Met à jour la souscription Stripe pour qu'elle ne soit pas annulée à la fin de la période
  def resume_stripe_subscription(subscription)
    subscription.cancel_at_period_end = false
    subscription.save
  end

  # Met à jour la souscription Stripe pour qu'elle soit annulée à la fin de la période
  def cancel_stripe_subscription(subscription)
    subscription.cancel_at_period_end = true
    subscription.save
  end
end
