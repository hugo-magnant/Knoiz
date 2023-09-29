class SpotifyTokenRefresher
  # Initialisation avec les données de l'utilisateur et de Spotify
  def initialize(user, spotify_user_data)
    @user = user
    @spotify_user_data = spotify_user_data
  end

  # Méthode principale pour rafraîchir les tokens Spotify
  def call
    # Sort de la méthode si le token n'a pas besoin d'être rafraîchi
    return unless token_needs_refresh?

    begin
      # Crée un nouvel objet User de RSpotify avec les données actuelles
      new_spotify_user = RSpotify::User.new(@spotify_user_data)
      # Convertit les données du nouvel utilisateur Spotify en hash
      updated_spotify_data = new_spotify_user.to_hash

      # Met à jour les données de la session Spotify
      update_spotify_session_data(updated_spotify_data)
      # Met à jour le profil de l'utilisateur avec les nouvelles données Spotify
      update_user_profile(updated_spotify_data)
    rescue RSpotify::Error => e # Capture les erreurs spécifiques à RSpotify
      Rails.logger.error("Erreur Spotify : #{e.message}")
      # Optionnellement, notifier un service de suivi des erreurs
    rescue StandardError => e # Capture les autres erreurs
      Rails.logger.error("Erreur générale : #{e.message}")
    end
  end

  private

  # Vérifie si le token Spotify doit être rafraîchi
  def token_needs_refresh?
    @user.profile.updated_at < 1.hour.ago
  end

  # Met à jour les données de session Spotify
  def update_spotify_session_data(updated_spotify_data)
    @spotify_user_data = updated_spotify_data
  end

  # Met à jour le profil utilisateur avec les nouvelles données Spotify
  def update_user_profile(updated_spotify_data)
    # Met à jour le nom d'utilisateur
    @user.update!(username: updated_spotify_data["display_name"])
    # Met à jour le profil
    @user.profile.update!(
      timestamp: Time.now,
      image: updated_spotify_data["images"].any? ? updated_spotify_data["images"].first["url"] : nil,
    )
  end
end
