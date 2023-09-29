class Stats
  include Sidekiq::Worker

  # Méthode appelée pour exécuter la tâche en arrière-plan
  def perform(spotify_user_content, spotify_user_id)
    # Initialisation des objets User et RSpotify::User
    current_user = User.find_by(id: spotify_user_id)
    spotify_user = RSpotify::User.new(spotify_user_content)

    # Récupération des 50 meilleures pistes à long terme de l'utilisateur
    temp_top_tracks = spotify_user.top_tracks(limit: 50, offset: 0, time_range: "long_term")

    # Récupération des genres associés aux meilleures pistes
    temp_genres = extract_genres_from_tracks(temp_top_tracks)

    # Calcul des genres les plus fréquents
    sorted_genres = calculate_top_genres(temp_genres)

    # Mise à jour des données Spotify de l'utilisateur
    update_user_data(current_user, sorted_genres)
  end

  private

  # Méthode pour extraire les genres des pistes
  def extract_genres_from_tracks(top_tracks)
    top_tracks.flat_map do |track|
      track.artists.first.genres.take(3)
    end.compact
  end

  # Méthode pour calculer les genres les plus fréquents
  def calculate_top_genres(genres)
    genre_count = Hash.new(0)
    genres.each { |genre| genre_count[genre] += 1 }
    genre_count.sort_by { |_genre, count| -count }.take(5)
  end

  # Méthode pour mettre à jour les données de l'utilisateur
  def update_user_data(user, top_genres)
    user.spotifydata.favorite_genre = top_genres
    user.spotifydata.save
  end
end
