class ChangeFavoriteGenreDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :spotifydata, :favorite_genre, [["Genre 1", 5], ["Genre 2", 4], ["Genre 3", 3], ["Genre 4", 2], ["Genre 5", 1]]
  end
end
