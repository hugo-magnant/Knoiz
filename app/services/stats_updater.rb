class StatsUpdater
  # Initialisation avec les données de l'utilisateur et de Spotify
  def initialize(user, spotify_user_data)
    @user = user
    @spotify_user_data = spotify_user_data
  end

  # Méthode principale pour mettre à jour les statistiques
  def call
    # Sort de la méthode si les statistiques n'ont pas besoin d'être mises à jour
    return unless stats_needs_updating?

    begin
      # La logique pour la mise à jour des statistiques est ici.
      # Appelle une tâche en arrière-plan pour effectuer les calculs.
      Stats.perform_async(@spotify_user_data, @user.id)
      # Met à jour le timestamp indiquant la dernière mise à jour des statistiques
      update_timestamp
    rescue StandardError => e # Capture les erreurs non spécifiques
      Rails.logger.error("General error in StatsUpdater: #{e.message}")
    end
  end

  private

  # Vérifie si les statistiques ont besoin d'être mises à jour.
  def stats_needs_updating?
    @user.spotifydata.timestamp <= 24.hours.ago
  end

  # Met à jour le timestamp pour spotifydata
  def update_timestamp
    @user.spotifydata.update!(timestamp: Time.now)
  end
end
