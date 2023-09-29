class StatsController < ApplicationController
  require "net/http"
  require "uri"
  require "json"

  GLOBAL_PLAYLIST_ID = "37i9dQZEVXbMDoHDwVN2tF".freeze

  before_action :ensure_logged_in
  before_action :access_token_refreshing
  before_action :verif_subscription, only: %i[recently tops top_global]
  before_action :initialize_spotify_user, only: %i[index recently tops]

  # Index : Statistiques principales de l'utilisateur
  def index
    fetch_stats
    params[:page] = "stats"
  end

  # Récemment joué : 50 dernières pistes jouées
  def recently
    fetch_recently_played(limit: 50)
    params[:page] = "recently"
  end

  # Tops : Les meilleures pistes, albums et artistes
  def tops
    fetch_top_tracks_and_artists(limit: 50)
    params[:page] = "tops"
  end

  # Top global : Top 50 des pistes mondiales
  def top_global
    fetch_top_global_tracks
    params[:page] = "top_global"
  end

  private

  # Vérifie si l'utilisateur est connecté
  def ensure_logged_in
    return if session[:user_id]

    flash[:alert] = "You must be logged in !"
    redirect_to root_path
  end

  # Rafraîchit le jeton d'accès Spotify si nécessaire
  def access_token_refreshing
    return unless need_to_refresh_token?

    refresh_spotify_user_data
    update_user_profile
  end

  # Vérifie si le jeton doit être rafraîchi
  def need_to_refresh_token?
    session[:user_id] && @current_user.profile.updated_at < 1.hour.ago
  end

  # Met à jour les données utilisateur de Spotify
  def refresh_spotify_user_data
    new_spotify_user = RSpotify::User.new(session[:spotify_user_data])
    session[:spotify_user_data] = new_spotify_user.to_hash
  end

  # Met à jour le profil utilisateur
  def update_user_profile
    profile_attributes = { timestamp: Time.now, image: new_spotify_user.images.first&.fetch("url") }
    @current_user.update(username: new_spotify_user.display_name)
    @current_user.profile.update(profile_attributes)
  end

  # Vérifie l'abonnement de l'utilisateur
  def verif_subscription
    return unless session[:user_id]
    return if @current_user.subscription.active

    flash[:alert] = "You must subscribe !"
    redirect_to pricing_path
  end

  # Initialise les données de l'utilisateur Spotify
  def initialize_spotify_user
    @spotify_user = RSpotify::User.new(session[:spotify_user_data])
    @oauth_token = @spotify_user.to_hash
  end

  # Récupère toutes les statistiques nécessaires
  def fetch_stats
    fetch_currently_playing
    fetch_recently_played
    fetch_top_tracks_and_artists
    fetch_top_global_tracks
  end

  # Récupère la piste en cours de lecture sur Spotify
  def fetch_currently_playing
    uri = URI.parse("https://api.spotify.com/v1/me/player/currently-playing")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{@oauth_token["credentials"]["token"]}"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.code == "200"
      response_json = JSON.parse(response.body)
      @is_playing_statut = response_json["is_playing"]
      @is_playing_album_image = response_json["item"]["album"]["images"][0]["url"]
      @is_playing_name = response_json["item"]["name"]
      @is_playing_artist = response_json["item"]["artists"][0]["name"]
      @is_playing_album = response_json["item"]["album"]["name"]
      @is_playing_track_link = response_json["item"]["external_urls"]["spotify"]
      @spotify_info = {
        image_url: @is_playing_album_image,
        name: @is_playing_name,
        artist: @is_playing_artist,
        album: @is_playing_album,
        track_link: @is_playing_track_link,
      }
    elsif response.code == "204"
      @last_played = @spotify_user.recently_played(limit: 1)
      @spotify_info = {
        image_url: @last_played.first.album.images.first["url"],
        name: @last_played.first.name,
        artist: @last_played.first.artists.first.name,
        album: @last_played.first.album.name,
        track_link: @last_played.first.external_urls["spotify"],
      }
    end
  end

  # Récupère les pistes récemment jouées
  def fetch_recently_played(limit: 5)
    @recently_played = @spotify_user.recently_played(limit: limit)
  end

  # Récupère les meilleures pistes et artistes de l'utilisateur
  def fetch_top_tracks_and_artists(limit: 5)
    time_ranges = %w[short_term medium_term long_term]
    time_ranges.each do |time_range|
      instance_variable_set("@top_tracks_#{time_range}", @spotify_user.top_tracks(limit: limit, time_range: time_range))
      instance_variable_set("@top_artists_#{time_range}", @spotify_user.top_artists(limit: limit, time_range: time_range))
    end
  end

  # Récupère le top 50 des pistes mondiales
  def fetch_top_global_tracks
    @top_global_playlist = RSpotify::Playlist.find_by_id(GLOBAL_PLAYLIST_ID)
    @top_global_tracks = @top_global_playlist.tracks.take(5)
  end
end
