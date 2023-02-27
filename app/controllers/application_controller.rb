class ApplicationController < ActionController::Base

    protect_from_forgery

    before_action :set_current_user
    before_action :check_stripe_subscription
    before_action :access_token_refreshing
    before_action :stats    

    def set_current_user
        if !session[:user_id].nil?
            @current_user = User.find_by(id: session[:user_id])
        end
    end

    def check_stripe_subscription
        if !session[:user_id].nil? and @current_user.subscription.active == true
            subscriptions = Stripe::Subscription.list(customer: @current_user.subscription.stripe_user_id)
            if subscriptions.data.any? { |sub| sub.status == 'active' }
            # User is currently subscribed
            else
                @current_user.subscription.active = false
                @current_user.subscription.stripe_user_id = ""
                @current_user.subscription.stripe_subscription_id = ""
                @current_user.subscription.save
            end
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

    def stats
        if !session[:user_id].nil? and !session[:spotify_user_data].nil?
            if @current_user.spotifydata.timestamp <= 24.hours.ago
                spotify_user_content = session[:spotify_user_data]
                spotify_user_id = @current_user.id
                @current_user.spotifydata.timestamp = Time.now
                @current_user.spotifydata.save
                Stats.perform_async(spotify_user_content, spotify_user_id)
            elsif @current_user.spotifydata.favorite_genre == nil
                spotify_user_content = session[:spotify_user_data]
                spotify_user_id = @current_user.id
                @current_user.spotifydata.timestamp = Time.now
                @current_user.spotifydata.save
                Stats.perform_async(spotify_user_content, spotify_user_id)
            end
        end
    end

end
