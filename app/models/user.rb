class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_one :subscription
  has_one :profile
  has_one :wallet
  has_one :spotifydata
  
  after_create :create_subscription
  after_create :create_profile
  after_create :create_wallet
  after_create :create_spotifydata

  def create_subscription
    Subscription.create(user_id: id) if subscription.nil?
  end

  def create_profile
    self.create_profile!
  end

  def create_wallet
    self.create_wallet!
  end

  def create_spotifydata
    self.create_spotifydata!
  end
  
  
  def self.from_omniauth(auth)
    user = User.find_or_create_by(spotify_id: auth.uid)
    user.update(
      name: auth.info.name,
      spotify_token: auth.credentials.token,
      spotify_refresh_token: auth.credentials.refresh_token
    )
    user
  end

end
