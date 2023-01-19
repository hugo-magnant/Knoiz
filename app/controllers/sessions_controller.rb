class SessionsController < ApplicationController
    def destroy
      reset_session
      redirect_to login_path
    end
end