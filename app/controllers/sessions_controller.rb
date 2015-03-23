class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def create
    auth = request.env["omniauth.auth"]
    # sign in or create new user
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) ||
        User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to '/', :notice => "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/calendar', :notice => "Signed out!"
  end
end
