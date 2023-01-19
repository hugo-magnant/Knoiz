class UsersController < ApplicationController

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    session[:spotify_user_data] = spotify_user.to_hash
    session[:access_token] = spotify_user.credentials.token
    redirect_to root_path
  end

end