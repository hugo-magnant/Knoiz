class Playlist
  include Sidekiq::Worker
  queue_as :default

  sidekiq_options retry: 5
 
  # Méthode appelée pour exécuter la tâche en arrière-plan
  def perform(text_search, spotify_user_content, spotify_user_id)
    # Initialiser le client OpenAI
    client = OpenAI::Client.new(access_token: ENV["OPENAI_KEY"])

    # Générer le titre de la playlist via OpenAI
    playlist_title = generate_playlist_title(client, text_search)

    # Générer la liste de chansons via OpenAI
    myArray = generate_song_list(client, text_search)

    # Convertir le tableau en JSON
    myArray_json = myArray.to_json

    # Appeler le travailleur Sidekiq pour créer la playlist sur Spotify
    Create.perform_async(myArray_json, spotify_user_content, spotify_user_id, playlist_title)

    # TODO: Décrémenter le solde de crédits de l'utilisateur
    # current_user.wallet.credits -= 1
    # current_user.wallet.save
  end

  private

  # Méthode pour générer le titre de la playlist
  def generate_playlist_title(client, text_search)

      require 'net/http'
      require 'json'
      require 'uri'
      
      uri = URI('https://api.openai.com/v1/chat/completions')
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request['Authorization'] = "Bearer #{ENV['OPENAI_KEY']}"
      request.body = JSON.dump({
        "model" => "gpt-4-turbo-preview",
        "messages" => [
          {
            "role" => "system",
            "content" => "Create a playlist title without quotes that matches this description : #{text_search}"
          }
        ],
        "temperature" => 1,
        "max_tokens" => 100,
        "top_p" => 1,
        "frequency_penalty" => 0,
        "presence_penalty" => 0
      })
      
      response_playlist_title = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
          
    response_json = JSON.parse(response_playlist_title.body)

    playlist_title = response_json["choices"].first["message"]["content"]
    clean_string(playlist_title)

    return playlist_title
  end

  # Méthode pour générer la liste de chansons
  def generate_song_list(client, text_search)
    require 'net/http'
    require 'json'
    require 'uri'
    
    uri = URI('https://api.openai.com/v1/chat/completions')
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{ENV['OPENAI_KEY']}"
    request.body = JSON.dump({
      "model" => "gpt-4-turbo-preview",
      "messages" => [
        {
          "role" => "system",
          "content" => "Create a playlist of strictly 30 songs by 30 different artists, all in a similar style and era to #{text_search}. Each song should be unique without any repetitions and should only list the main artist, excluding any featured artists. I want the output presented as text that resembles JSON format, with each entry combining the song and artist into a single string under a 'Track' key. The entries should be formatted like this: ( Track : Song Title - Artist Name ). Please generate the playlist in this mock JSON text format."
        }
      ],
      "temperature" => 1,
      "max_tokens" => 800,
      "top_p" => 1,
      "frequency_penalty" => 0,
      "presence_penalty" => 0
    })
    
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    response_json = JSON.parse(response.body)
    response_ai = response_json["choices"].first["message"]["content"]

    tracks_array = JSON.parse(response_ai.gsub("```json", "").gsub("```", "").strip)
# Extraire seulement les chaînes "Track"
    track_strings = tracks_array.map { |track| track["Track"] }

    return track_strings

  end

  # Méthode pour nettoyer les chaînes de caractères provenant d'OpenAI
  def clean_string(str)
    # Supprimer les caractères d'échappement, les guillemets, les crochets, et les backslashes
    str = str.gsub(/\\n|\"|\[|\]|\\/, "")
    
  end
end
