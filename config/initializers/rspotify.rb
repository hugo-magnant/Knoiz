require 'rspotify/oauth'
require_relative '../../.spotify_key.rb'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "#{$spotify_id}", "#{$spotify_key}", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end

OmniAuth.config.allowed_request_methods = [:post, :get]