class Create
    include Sidekiq::Worker
  
    sidekiq_options retry: false

    def perform(myArray_json, spotify_user_content, spotify_user_id, playlist_title)

        require 'base64'
        require 'json'

        current_user = User.find_by(id: spotify_user_id)
        spotify_user = RSpotify::User.new(spotify_user_content)

        image_data = File.read("app/assets/images/knoiz-logo-bg-blanc.png")
        encoded_image_data = Base64.strict_encode64(image_data)

        myArray = JSON.parse(myArray_json)
        temp_playlist = []

        for song in myArray do
            track = RSpotify::Track.search(song).first
            temp_playlist.append(track)
        end
        
        if temp_playlist.present?
            playlist = spotify_user.create_playlist!("Knoiz | #{playlist_title}")
            playlist.add_tracks!(temp_playlist)
            playlist.replace_image!(encoded_image_data, 'image/jpeg')
        end
 
    end

end