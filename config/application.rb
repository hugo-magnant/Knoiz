require_relative "boot"
require "rails/all"

require "dotenv/load"

Bundler.require(*Rails.groups)

module Knoiz
  class Application < Rails::Application
    config.load_defaults 7.0
    config.require_master_key = true

    RSpotify::authenticate(ENV["SPOTIFY_ID"], ENV["SPOTIFY_KEY"])
  end
end
