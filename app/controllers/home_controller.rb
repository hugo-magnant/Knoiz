class HomeController < ApplicationController

    before_action :authenticate_user, only: [:create_playlist]
    before_action :access_token_refreshing, only: [:create_playlist]

    def index
        
    end

    def create_playlist

        if !session[:user_id].nil?
            if @current_user.subscription.active == false and @current_user.wallet.timestamp < 24.hours.ago
                require_relative '../workers/playlist.rb'

                spotify_user_content = session[:spotify_user_data]
                spotify_user_id = @current_user.id

                puts spotify_user_content

                text_search = params[:text_search].squish

                Playlist.perform_async(text_search, spotify_user_content, spotify_user_id)

                @current_user.wallet.timestamp = Time.now
                @current_user.wallet.save

                flash[:notice] = "Your playlist is being created."
                redirect_to root_path
            elsif @current_user.subscription.active == true and @current_user.wallet.timestamp < 1.minute.ago
                require_relative '../workers/playlist.rb'

                spotify_user_content = session[:spotify_user_data]
                spotify_user_id = @current_user.id

                puts spotify_user_content

                text_search = params[:text_search].squish

                Playlist.perform_async(text_search, spotify_user_content, spotify_user_id)

                @current_user.wallet.timestamp = Time.now
                @current_user.wallet.save

                flash[:notice] = "Your playlist is being created."
                redirect_to root_path
            else
                flash[:alert] = "You can't create a playlist now."
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
        end
    end

end


