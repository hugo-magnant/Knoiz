class Stats
    include Sidekiq::Worker
  
    def perform(spotify_user_content, spotify_user_id)

        spotify_user = RSpotify::User.new(spotify_user_content)
        current_user = User.find_by(id: spotify_user_id)

        temp_top_tracks = []
        temp_top_artists_long_term = spotify_user.top_tracks(limit: 50, offset: 0, time_range: 'long_term')
        temp_top_artists_long_term.each do |track|
            temp_top_tracks.append(track)
        end
        temp_genres= []
        temp_top_tracks.each do |track|
            temp_genres.append(track.artists.first.genres.first)
            temp_genres.append(track.artists.first.genres.second)
            temp_genres.append(track.artists.first.genres.third)
        end
        top_genres_storage = []
        temp_genres.compact!
        while temp_genres.size > 0
            temp_count = temp_genres.count(temp_genres[0])
            temp_array_genres_final = [temp_genres[0], temp_count]
            top_genres_storage.append(temp_array_genres_final)
            temp_genres.delete(temp_genres[0])
        end

        sorted_genres = top_genres_storage.sort_by { |genre, count| -count }
        current_user.spotifydata.favorite_genre = sorted_genres.take(5)
        current_user.spotifydata.save
        
    end
end