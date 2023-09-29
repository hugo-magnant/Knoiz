class Playlist
  include Sidekiq::Worker

  # Options spécifiques à Sidekiq
  sidekiq_options retry: false

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
    response_playlist_title = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: "Create a playlist title that matches this description : \"#{text_search}\"",
        temperature: 0.7,
        max_tokens: 100,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0,
      },
    )

    playlist_title = response_playlist_title["choices"].map { |c| c["text"] }.join
    clean_string(playlist_title)
  end

  # Méthode pour générer la liste de chansons
  def generate_song_list(client, text_search)
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: "Create in one column : a playlist of strictly 30 songs made by strictly 30 different artists in the same style and the same era of #{text_search}. Don't put the same music more than once. Items must be separated by |. Song and artist must be separate by -. Don't write the feats, only the main music artist.",
        temperature: 0.7,
        max_tokens: 500,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0,
      },
    )

    response_ai = response["choices"].map { |c| c["text"] }.join
    clean_string(response_ai).split("|")
  end

  # Méthode pour nettoyer les chaînes de caractères provenant d'OpenAI
  def clean_string(str)
    str.gsub(/\\n|\"|\[|\]|\\/, "")
  end
end
