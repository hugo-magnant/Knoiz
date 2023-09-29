class SessionsController < ApplicationController
  # Crée une session utilisateur
  def create
    spotify_user = initialize_spotify_user
    store_spotify_data_in_session(spotify_user)

    user = find_or_create_user(spotify_user)
    update_user_profile!(user, spotify_user)

    start_user_session(user)
    redirect_with_welcome_message(user)
  rescue => e
    Rails.logger.error("Erreur dans SessionsController#create : #{e.message}")
  end

  # Détruit la session utilisateur
  def destroy
    end_user_session
    redirect_with_logout_message
  end

  private

  # Initialise un utilisateur Spotify à partir de l'authentification OmniAuth
  def initialize_spotify_user
    RSpotify::User.new(request.env["omniauth.auth"])
  end

  # Stocke les données Spotify de l'utilisateur dans la session
  def store_spotify_data_in_session(spotify_user)
    session[:spotify_user_data] = spotify_user.to_hash
  end

  # Trouve ou crée un utilisateur dans la base de données
  def find_or_create_user(spotify_user)
    User.find_or_create_by(spotify_id: spotify_user.id).tap do |user|
      user.username = spotify_user.display_name
      user.save!
    end
  end

  # Met à jour le profil de l'utilisateur
  def update_user_profile!(user, spotify_user)
    user.profile.update!(build_profile_data(spotify_user))
  end

  # Construit un hash de données pour mettre à jour le profil
  def build_profile_data(spotify_user)
    {
      timestamp: Time.now,
      image: spotify_user.images.first&.dig("url"),
    }.compact
  end

  # Initialise la session utilisateur
  def start_user_session(user)
    session[:user_id] = user.id
  end

  # Redirige vers la page d'accueil avec un message de bienvenue
  def redirect_with_welcome_message(user)
    redirect_to root_path, notice: "Welcome, #{user.username} !" # Modifié ici
  end

  # Réinitialise la session utilisateur
  def end_user_session
    reset_session
  end

  # Redirige vers la page d'accueil avec un message de déconnexion
  def redirect_with_logout_message
    redirect_to root_path, notice: "Logged out !"
  end
end
