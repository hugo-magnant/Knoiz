class HomeController < ApplicationController

    def index

    end

    def create_playlist

        require_relative '../../.openai_key.rb'

        spotify_user = RSpotify::User.new(session[:spotify_user_data])

        song = params[:text_song].squish
        artist = params[:text_artist].squish

        client = OpenAI::Client.new(access_token: $openai_key)

        tracks = RSpotify::Track.search('Know')

        response = client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: "Create in a one column : a playlist of 30 songs made by different artists in the style of #{artist}'s \"#{song}\" music. Items must be separate by |. Song and artist must be separate by -. Don't write the feats, only the main music artist.",
                temperature: 1,
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

        playlist = spotify_user.create_playlist!("Djai.app | #{song} - #{artist}")
        temp_playlist = []

        for song in @myArray do

            track = RSpotify::Track.search(song).first
            temp_playlist.append(track)

        end

        playlist.add_tracks!(temp_playlist)

        redirect_to root_path

    end

end