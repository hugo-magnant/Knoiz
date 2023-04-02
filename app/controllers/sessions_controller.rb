class SessionsController < ApplicationController
  def create
    auth_hash = request.env["omniauth.auth"]
    spotify_user = RSpotify::User.new(auth_hash)
    session[:spotify_user_data] = spotify_user.to_hash
    @user = User.find_by(spotify_id: spotify_user.id)

    if @user.nil?
      @user = User.create(
        username: spotify_user.display_name,
        spotify_id: spotify_user.id,
      )
      @user.profile.update(timestamp: Time.now)
      if spotify_user.images.any?
        @user.profile.update(image: spotify_user.images.first["url"])
      else
        @user.profile.update(image: nil)
      end
    else
      # Update the access_token and refresh_token if the user exists
      @user.update(username: spotify_user.display_name)
      @user.profile.update(timestamp: Time.now)
      if spotify_user.images.any?
        @user.profile.update(image: spotify_user.images.first["url"])
      else
        @user.profile.update(image: nil)
      end
    end

    session[:user_id] = @user.id
    redirect_to root_path, notice: "Welcome, #{@user.username}!"
  end

  def destroy
    session[:user_id] = nil
    session[:spotify_user_data] = nil
    redirect_to root_path, notice: "Logged out!"
  end
end
