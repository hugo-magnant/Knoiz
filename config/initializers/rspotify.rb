require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_ID'], ENV['SPOTIFY_KEY'], scope: 'user-read-email playlist-modify-public playlist-modify-private ugc-image-upload user-library-read user-library-modify'
end

OmniAuth.config.allowed_request_methods = [:post, :get]