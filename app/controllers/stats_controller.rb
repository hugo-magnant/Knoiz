class StatsController < ApplicationController

    before_action :access_token_refreshing
    before_action :verif_subscription, only: [:recently, :tops, :top_global]

    def index
        if !session[:user_id].nil?

            # Connexion

            spotify_user_content = session[:spotify_user_data]
            spotify_user = RSpotify::User.new(spotify_user_content)
            oauth_token = spotify_user.to_hash

            # First stats
            
                # Currently paused on spotify

                require 'net/http'
                require 'uri'
                require 'json'

                uri = URI.parse("https://api.spotify.com/v1/me/player/currently-playing")
                request = Net::HTTP::Get.new(uri)
                request.content_type = "application/json"
                request["Accept"] = "application/json"
                request["Authorization"] = "Bearer #{oauth_token['credentials']['token']}"

                req_options = {
                    use_ssl: uri.scheme == "https",
                }

                response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                    http.request(request)
                end

                if response.code == '200'

                    response_json = JSON.parse(response.body)
                    @is_playing_statut = response_json["is_playing"]
                    @is_playing_album_image = response_json['item']['album']['images'][0]['url']
                    @is_playing_name = response_json["item"]["name"]
                    @is_playing_artist = response_json['item']['artists'][0]['name']
                    @is_playing_album = response_json['item']['album']['name']
                    @is_playing_track_link = response_json['item']['external_urls']['spotify']
                    
                elsif response.code == '204'

                    @last_played = spotify_user.recently_played(limit: 1)

                end

                # Echantillon 5 recently played
                
                @recently_played = spotify_user.recently_played(limit: 5)

            # Top user

                # Echantillon tops 5 Tracks

                @top_tracks_short_term = spotify_user.top_tracks(limit: 5, offset: 0, time_range: 'short_term')
                @top_tracks_medium_term = spotify_user.top_tracks(limit: 5, offset: 0, time_range: 'medium_term')
                @top_tracks_long_term = spotify_user.top_tracks(limit: 5, offset: 0, time_range: 'long_term')

                # Echantillon tops 5 artistes

                @top_artists_short_term = spotify_user.top_artists(limit: 5, offset: 0, time_range: 'short_term')
                @top_artists_medium_term = spotify_user.top_artists(limit: 5, offset: 0, time_range: 'medium_term')
                @top_artists_long_term = spotify_user.top_artists(limit: 5, offset: 0, time_range: 'long_term')


            # Echantillon tops 5 tracks global

            top_global_playlist_preview = RSpotify::Playlist.find_by_id('37i9dQZEVXbMDoHDwVN2tF')
            @top_global_tracks = top_global_playlist_preview.tracks.take(5)

        end

        params[:page] = "stats"

    end

    def recently

        params[:page] = "recently"

        if !session[:user_id].nil?

            # Connexion

            spotify_user_content = session[:spotify_user_data]
            spotify_user = RSpotify::User.new(spotify_user_content)
            

            # 50 recently played
            
            @recently_played = spotify_user.recently_played(limit: 50)

        end

    end

    def tops

        params[:page] = "tops"

        if !session[:user_id].nil?

            # Connexion

            spotify_user_content = session[:spotify_user_data]
            spotify_user = RSpotify::User.new(spotify_user_content)


            # 50 top User Tracks 

            @top_tracks_short_term = spotify_user.top_tracks(limit: 50, offset: 0, time_range: 'short_term')
            @top_tracks_medium_term = spotify_user.top_tracks(limit: 50, offset: 0, time_range: 'medium_term')
            @top_tracks_long_term = spotify_user.top_tracks(limit: 50, offset: 0, time_range: 'long_term')


            # 50 top User Albums

            @top_albums_short_term = []
            @top_tracks_short_term.each do |track|
                @top_albums_short_term.append(track.album)
            end
            @top_albums_medium_term = []
            @top_tracks_medium_term.each do |track|
                @top_albums_medium_term.append(track.album)
            end
            @top_albums_long_term = []
            @top_tracks_long_term.each do |track|
                @top_albums_long_term.append(track.album)
            end


            # 50 top User Artists

            @top_artists_short_term = spotify_user.top_artists(limit: 50, offset: 0, time_range: 'short_term')
            @top_artists_medium_term = spotify_user.top_artists(limit: 50, offset: 0, time_range: 'medium_term')
            @top_artists_long_term = spotify_user.top_artists(limit: 50, offset: 0, time_range: 'long_term')

        end

    end

    def top_global

        # Extraction de la playlist top 50 global pour tracks du moment

        @top_global_playlist = RSpotify::Playlist.find_by_id('37i9dQZEVXbMDoHDwVN2tF')
        
        params[:page] = "top_global"

    end

    private

    def access_token_refreshing
        if !session[:user_id].nil?
            if @current_user.profile.updated_at < 1.hour.ago
 
                new_spotify_user = RSpotify::User.new(session[:spotify_user_data])
                session[:spotify_user_data] = new_spotify_user.to_hash

                @current_user.update(username: new_spotify_user.display_name, email: new_spotify_user.email)
                @current_user.profile.update(timestamp: Time.now)
                if new_spotify_user.images.any?
                  @current_user.profile.update(image: new_spotify_user.images.first['url'])
                else
                  @current_user.profile.update(image: nil)
                end

            end
        else
            flash[:alert] = "You must be logged in !"
            redirect_to root_path
        end
    end

    def verif_subscription 
        if !session[:user_id].nil?
            if @current_user.subscription.active == false
                flash[:alert] = "You must be subscribe !"
                redirect_to pricing_path
            end
        end
    end

end


