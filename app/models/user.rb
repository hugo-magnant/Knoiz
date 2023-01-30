class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_one :subscription
  has_one :profile
  
  after_create :create_subscription
  after_create :create_profile

  def create_subscription
    Subscription.create(user_id: id) if subscription.nil?
  end

  def create_profile
    self.create_profile!
  end
  
  
  def self.from_omniauth(auth)
    user = User.find_or_create_by(spotify_id: auth.uid)
    user.update(
      name: auth.info.name,
      email: auth.info.email,
      spotify_token: auth.credentials.token,
      spotify_refresh_token: auth.credentials.refresh_token
    )
    user
  end


  def reset_credits_unsubscribe
    # Sélectionne les utilisateurs qui n'ont pas d'abonnement actif
    unsubscribe_users = User.joins(:subscription).where(subscriptions: { active: false })
    # Réinitialise la valeur de crédits pour les utilisateurs sélectionnés
    unsubscribe_users.each { |user| user.profile.update(credits: 1) }
  end

  def reset_credits_subscribe
    # Sélectionne les utilisateurs qui n'ont pas d'abonnement actif
    subscribe_users = User.joins(:subscription).where(subscriptions: { active: true })
    # Réinitialise la valeur de crédits pour les utilisateurs sélectionnés
    subscribe_users.each { |user| user.profile.update(credits: 100) }
  end

end
