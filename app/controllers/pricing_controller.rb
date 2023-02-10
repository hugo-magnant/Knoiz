class PricingController < ApplicationController
    
    before_action :authenticate_user, only: [:create_playlist]
    before_action :access_token_refreshing, only: [:create_playlist]

    def index

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