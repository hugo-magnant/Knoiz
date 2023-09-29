module SpotifyConcern
  extend ActiveSupport::Concern

  included do
    before_action :refresh_spotify_access_token
  end

  private

  # Méthode pour rafraîchir le token Spotify
  def refresh_spotify_access_token
    # Sortir tôt si l'utilisateur n'est pas connecté ou si un rafraîchissement n'est pas nécessaire
    return unless @current_user && needs_spotify_token_refresh?
    # Appeler le service SpotifyTokenRefresher pour gérer le rafraîchissement
    SpotifyTokenRefresher.new(@current_user, session[:spotify_user_data]).call
  end

  # Méthode pour vérifier si un rafraîchissement du token Spotify est nécessaire et retourne vrai si le profil a été mis à jour il y a plus d'une heure
  def needs_spotify_token_refresh?
    @current_user.profile.updated_at < 1.hour.ago
  end
end
