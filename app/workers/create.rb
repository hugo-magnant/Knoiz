class Create
  include Sidekiq::Worker

  # Options spécifiques à Sidekiq
  sidekiq_options retry: false

  # Bibliothèques requises déplacées en dehors de la méthode `perform`
  require "base64"
  require "json"

  # Méthode appelée pour exécuter la tâche en arrière-plan
  def perform(myArray_json, spotify_user_content, spotify_user_id, playlist_title)
    # Trouver l'utilisateur actuel en utilisant son ID Spotify
    current_user = User.find_by(id: spotify_user_id)

    # Initialiser un objet utilisateur RSpotify
    spotify_user = RSpotify::User.new(spotify_user_content)

    # Charger et encoder en Base64 l'image de la playlist
    image_data = File.read("app/assets/images/knoiz-logo-bg-blanc.png")
    encoded_image_data = Base64.strict_encode64(image_data)

    # Convertir le JSON en tableau Ruby
    myArray = JSON.parse(myArray_json)
    temp_playlist = []

    # Rechercher et ajouter des chansons à la playlist temporaire
    myArray.each do |song|
      track = RSpotify::Track.search(song).first
      temp_playlist.append(track) if track # ajout d'une vérification
    end

    # Créer la playlist si des chansons ont été trouvées
    if temp_playlist.present?
      playlist = spotify_user.create_playlist!("Knoiz | #{playlist_title}")
      playlist.add_tracks!(temp_playlist)
      playlist.replace_image!(encoded_image_data, "image/jpeg")
    end
  end
end
