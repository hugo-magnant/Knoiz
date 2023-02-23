class Playlist
    include Sidekiq::Worker
  
    def perform(text_search, spotify_user_content, spotify_user_id)

        client = OpenAI::Client.new(access_token: ENV['OPENAI_KEY'])


        response_playlist_title = client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: "Create a playlist title that matches this description : \"#{text_search}\"",
                temperature: 0.7,
                max_tokens: 1000,
                top_p: 1,
                frequency_penalty: 0,
                presence_penalty: 0
            })

        playlist_title = response_playlist_title["choices"].map { |c| c["text"] }
        
        playlist_title = playlist_title.to_s
        playlist_title = playlist_title.gsub!("\\n", "")
        playlist_title = playlist_title.gsub!("\"", "")
        playlist_title = playlist_title.gsub!("[", "")
        playlist_title = playlist_title.gsub!("]", "")
        playlist_title = playlist_title.gsub!("\\", "")

        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts playlist_title
        puts "_________________________________________________________"
        puts "_________________________________________________________"



        response = client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: "Create in one column : a playlist of strictly 30 songs made by strictly 30 different artists in the same style and the same era of #{text_search}. Don't put the same music more than once. Items must be separated by |. Song and artist must be separate by -. Don't write the feats, only the main music artist.",
                temperature: 0.7,
                max_tokens: 1000,
                top_p: 1,
                frequency_penalty: 0,
                presence_penalty: 0
            })

        reponse_ai = response["choices"].map { |c| c["text"] }
        reponse_ai = reponse_ai.to_s
        reponse_ai = reponse_ai.gsub!("\\n", "")
        reponse_ai = reponse_ai.gsub!("\"", "")
        reponse_ai = reponse_ai.gsub!("[", "")
        reponse_ai = reponse_ai.gsub!("]", "")
    

        myArray = reponse_ai.split("|")
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        puts myArray
        puts "_________________________________________________________"
        puts "_________________________________________________________"
        myArray_json = myArray.to_json


        Create.perform_async(myArray_json, spotify_user_content, spotify_user_id, playlist_title)

        #current_user.wallet.credits -= 1
        #current_user.wallet.save

    end

end