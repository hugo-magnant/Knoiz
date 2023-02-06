class Playlist
    include Sidekiq::Worker
  
    def perform(text_song, text_artist, spotify_user_content, spotify_user_id)

        require 'base64'

        current_user = User.find_by(id: spotify_user_id)
    
        image_data = File.read("app/assets/images/dlogo.jpeg")
        encoded_image_data = Base64.strict_encode64(image_data)

        spotify_user = RSpotify::User.new(spotify_user_content)

        client = OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])

        search_track = RSpotify::Track.search("#{text_song} - #{text_artist}").first
        search_track_name = search_track.name
        search_track_artist = search_track.artists.first.name

        var_temp = 0.7

        response = client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: "Create in one column : a playlist of strictly 30 songs made by strictly 30 different artists in the same style and the same era of #{text_artist}'s \"#{text_song}\" music including #{text_artist}'s \"#{text_song}\" music in first position. Don't put the same music more than once. Items must be separated by |. Song and artist must be separate by -. Don't write the feats, only the main music artist.",
                temperature: var_temp,
                max_tokens: 1000,
                top_p: 1,
                frequency_penalty: 0,
                presence_penalty: 0
            })

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

        playlist = spotify_user.create_playlist!("Spotilab.ai | #{search_track_name} - #{search_track_artist}")
        playlist.replace_image!(encoded_image_data, 'image/jpeg')
        playlist.add_tracks!(temp_playlist)

        current_user.profile.credits -= 1
        current_user.profile.save

    end
end