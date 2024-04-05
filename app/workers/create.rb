class Create
  include Sidekiq::Worker

  # Options spécifiques à Sidekiq
  sidekiq_options retry: false

  # Bibliothèques requises déplacées en dehors de la méthode `perform`
  require "base64"
  require "json"
  require 'httparty'
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

    tracks_string = temp_playlist.map { |track| "spotify%3Atrack%3A#{track.id}" }.join('%2C')

    # Créer la playlist si des chansons ont été trouvées
    if temp_playlist.present?
      playlist = spotify_user.create_playlist!("Knoiz | #{playlist_title}")
      
      response = HTTParty.post("https://api.spotify.com/v1/playlists/#{playlist.id}/tracks?position=0&uris=#{tracks_string}",
        headers: {
          "Authorization" => "Bearer #{spotify_user.credentials['token']}",
          "Content-Type" => "application/json"
        },
        body: {
          uris: ["string"],
          position: 0
        }.to_json
      )

      image_data = File.read("app/assets/images/knoiz-logo-bg-blanc.png")
      encoded_image_data = Base64.strict_encode64(image_data)
  
      # Exécution de la requête PUT
      response = HTTParty.put("https://api.spotify.com/v1/playlists/#{playlist.id}/images",
        headers: {
          "Authorization" => "Bearer #{spotify_user.credentials['token']}",
          "Content-Type" => "image/jpeg"
        },
        body: encoded_image_data
      )

    end
  end
end
