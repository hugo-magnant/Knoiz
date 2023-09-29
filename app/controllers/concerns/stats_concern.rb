module StatsConcern
  extend ActiveSupport::Concern

  included do
    before_action :collect_stats
  end

  private

  # Méthode privée qui déclenche la collecte de statistiques
  def collect_stats
    # Appelle une autre méthode pour décider si les statistiques doivent être collectées ou non
    collect_stats_if_needed
  end

  # Méthode privée qui vérifie si la collecte de statistiques est nécessaire
  def collect_stats_if_needed
    # Sort de la méthode si la collecte de statistiques n'est pas nécessaire
    return unless stats_collection_required?
    # Si nécessaire, crée une nouvelle instance de StatsUpdater et appelle sa méthode "call"
    StatsUpdater.new(@current_user, session[:spotify_user_data]).call
  end

  # Méthode privée pour vérifier si la collecte de statistiques est nécessaire
  def stats_collection_required?
    # Récupère le timestamp associé aux données Spotify de l'utilisateur courant
    timestamp = @current_user&.spotifydata&.timestamp
    # Vérifie si le timestamp est présent et si les données ont plus de 24 heures
    timestamp.present? && timestamp <= 24.hours.ago.in_time_zone
  end
end
