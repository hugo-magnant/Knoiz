class Playlist
    include Sidekiq::Worker
  
    def perform(text_search, spotify_user_content, spotify_user_id)

        require 'base64'

        current_user = User.find_by(id: spotify_user_id)
    
        image_data = File.read("app/assets/images/dlogo.jpeg")
        encoded_image_data = Base64.strict_encode64(image_data)

        spotify_user = RSpotify::User.new(spotify_user_content)

        client = OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])

        response_playlist_title = client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: "Create a playlist title that matches this description : \"#{text_search}\"",
                temperature: 0.7,
                max_tokens: 1000,
                top_p: 1,
                frequency_penalty: 0,
                presence_penalty: 0
            })

        playlist_title = response_playlist_title["choices"].map { |c| c["text"] }
        
        playlist_title = playlist_title.to_s
        playlist_title = playlist_title.gsub!("\\n", "")
        playlist_title = playlist_title.gsub!("\"", "")
        playlist_title = playlist_title.gsub!("[", "")
        playlist_title = playlist_title.gsub!("]", "")
        playlist_title = playlist_title.gsub!("\\", "")

        response = client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: "Create in one column : a playlist of strictly 30 songs made by strictly 30 different artists in the same style and the same era of #{text_search}. Don't put the same music more than once. Items must be separated by |. Song and artist must be separate by -. Don't write the feats, only the main music artist.",
                temperature: 0.7,
                max_tokens: 1000,
                top_p: 1,
                frequency_penalty: 0,
                presence_penalty: 0
            })

            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts response
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"
            puts "_________________________________________________________"

        reponse_ai = response["choices"].map { |c| c["text"] }
        reponse_ai = reponse_ai.to_s
        reponse_ai = reponse_ai.gsub!("\\n", "")
        reponse_ai = reponse_ai.gsub!("\"", "")
        reponse_ai = reponse_ai.gsub!("[", "")
        reponse_ai = reponse_ai.gsub!("]", "")
        
        @myArray = reponse_ai.split("|")


        temp_playlist = []

        for song in @myArray do

            track = RSpotify::Track.search(song).first
            temp_playlist.append(track)

        end

        @playlist = spotify_user.create_playlist!("Spotilab.ai | #{playlist_title}")
        @playlist.replace_image!(encoded_image_data, 'image/jpeg')
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts temp_playlist
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts "_________________________________________________________"

        @playlist.add_tracks!(temp_playlist)
        @playlist_id = @playlist.id

        current_user.wallet.credits -= 1
        current_user.wallet.save

    end


    def on_failure(_exception, text_search, spotify_user_content, spotify_user_id)
        RSpotify::User.new(spotify_user_content).playlist(@playlist_id).delete
    end

end