class SomeController < ApplicationController
    before_action :authenticate_user
  
    def index
      # Your code here
    end
  
    private
    def authenticate_user
      redirect_to login_path unless session[:spotify_user_data]
    end
end