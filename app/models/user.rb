class User < ApplicationRecord
  has_one :subscription, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_one :wallet, dependent: :destroy
  has_one :spotifydata, dependent: :destroy

  after_create :initialize_related_models

  def initialize_related_models
    create_subscription
    create_profile
    create_wallet
    create_spotifydata
  end

  def create_subscription
    create_subscription!
  end

  def create_profile
    create_profile!
  end

  def create_wallet
    create_wallet!
  end

  def create_spotifydata
    create_spotifydata!
  end

  def self.from_omniauth(auth)
    where(spotify_id: auth.uid).first_or_initialize.tap do |user|
      user.name = auth.info.name
      user.spotify_token = auth.credentials.token
      user.spotify_refresh_token = auth.credentials.refresh_token
      user.save!
    end
  end
end
