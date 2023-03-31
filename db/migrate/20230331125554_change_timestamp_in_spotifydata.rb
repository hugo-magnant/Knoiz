class ChangeTimestampInSpotifydata < ActiveRecord::Migration[7.0]

    def up
      change_column_default :spotifydata, :timestamp, from: -> {'CURRENT_TIMESTAMP'}, to: '2022-12-31 23:00:00'
    end
  
    def down
      change_column_default :spotifydata, :timestamp, from: '2022-12-31 23:00:00', to: -> {'CURRENT_TIMESTAMP'}
    end

end
