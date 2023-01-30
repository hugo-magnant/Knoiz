class HomeController < ApplicationController

    before_action :authenticate_user, only: [:create_playlist]

    def index

    end

    def pricing

    end

    def faq

    end

    def create_playlist

        if !session[:user_id].nil?
            if @current_user.profile.credits > 0

                require 'base64'
    
                image_data = File.read("app/assets/images/dlogo.jpeg")
                encoded_image_data = Base64.strict_encode64(image_data)

                spotify_user = RSpotify::User.new(session[:spotify_user_data])
                client = OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])
    
                text_song = params[:text_song].squish
                text_artist = params[:text_artist].squish
    
                search_track = RSpotify::Track.search("#{text_song} - #{text_artist}").first
                search_track_name = search_track.name
                search_track_artist = search_track.artists.first.name
    
                var_temp = 0.7
    
                response = client.completions(
                    parameters: {
                        model: "text-davinci-003",
                        prompt: "Create in one column : a playlist of 30 songs made by different artists in the style of #{text_artist}'s \"#{text_song}\" music. Items must be separated by |. Song and artist must be separate by -. Don't write the feats, only the main music artist.",
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
    
                playlist = spotify_user.create_playlist!("Djai.app | #{search_track_name} - #{search_track_artist}")
                playlist.add_tracks!(temp_playlist)
    
                playlist.replace_image!(encoded_image_data, 'image/jpeg')
    
                @current_user.profile.credits -= 1
                @current_user.profile.save
    
                redirect_to root_path
    
            else
                flash[:alert] = "You don't have enough credits to perform this action"
                redirect_to root_path
            end
        end
    end

    private

    def authenticate_user
        if session[:user_id].nil?
            redirect_to root_path, alert: "You must be logged in to spotify."
        end
    end

end


