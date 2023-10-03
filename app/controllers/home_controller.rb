class HomeController < ApplicationController
  before_action :authenticate_user, only: [:create_playlist]
  before_action :refresh_access_token, only: [:create_playlist]
  before_action :check_eligibility, only: [:create_playlist]
  before_action :require_playlist_worker, only: [:create_playlist]

  def index
  end

  def create_playlist
    create_playlist_worker
    update_wallet_timestamp
    flash[:notice] = success_message
    redirect_to root_path
  end

  private

  # Authentification de l'utilisateur
  def authenticate_user
    redirect_to root_path, alert: "You must be logged in to Spotify." if session[:user_id].nil?
  end

  # Rafraîchissement du token Spotify si nécessaire
  def refresh_access_token
    return unless should_refresh_token?

    new_spotify_user = RSpotify::User.new(session[:spotify_user_data])
    update_spotify_data(new_spotify_user)
  end

  # Vérifie si l'utilisateur est éligible pour créer une playlist
  def check_eligibility
    return if eligible_for_playlist?

    flash[:alert] = "You can't create a playlist now."
    redirect_to root_path
  end

  # Charge le worker pour la création de playlist
  def require_playlist_worker
    require_relative "../workers/playlist.rb"  # Ceci pourrait aussi être déplacé dans un fichier d'initialisation
  end

  # Vérifie si le token Spotify doit être rafraîchi
  def should_refresh_token?
    @current_user&.profile&.updated_at < 1.hour.ago
  end

  # Met à jour les données utilisateur de Spotify
  def update_spotify_data(new_spotify_user)
    session[:spotify_user_data] = new_spotify_user.to_hash
    @current_user.update(username: new_spotify_user.display_name)
    @current_user.profile.update(timestamp: Time.now, image: new_spotify_user.images.first&.dig("url"))
  end

  # Vérifie si l'utilisateur est éligible pour créer une playlist
  def eligible_for_playlist?
    wallet_time_limit = @current_user.subscription.active ? 1.minute.ago : 1.week.ago
    @current_user.wallet.timestamp < wallet_time_limit
  end

  # Lance le worker pour créer la playlist
  def create_playlist_worker
    text_search = params[:text_search].squish
    Playlist.perform_async(text_search, session[:spotify_user_data], @current_user.id)
  end

  # Met à jour le timestamp du "wallet" de l'utilisateur
  def update_wallet_timestamp
    @current_user.wallet.update!(timestamp: Time.now)
  end

  # Message de succès pour la création de la playlist
  def success_message
    "Your playlist is being created. Find it soon in your Spotify playlists."
  end
end
