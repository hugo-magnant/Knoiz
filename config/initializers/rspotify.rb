require 'rspotify/oauth'

OmniAuth.config.silence_get_warning = true
OmniAuth.config.allowed_request_methods = [:post, :get]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_ID'], ENV['SPOTIFY_KEY'], scope: 'user-read-currently-playing user-top-read playlist-modify-public ugc-image-upload user-read-recently-played'
end