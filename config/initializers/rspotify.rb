require 'rspotify/oauth'

OmniAuth.config.silence_get_warning = true
OmniAuth.config.allowed_request_methods = [:post, :get]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_ID'], ENV['SPOTIFY_KEY'], scope: 'user-read-email playlist-modify-public playlist-modify-private ugc-image-upload user-library-read user-library-modify'
end