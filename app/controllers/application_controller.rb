class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def token
    # check if token is expired
    if not current_user
      return nil
    #elsif Time.at(current_user.expires_at) < Time.now
    else        # testing, refresh token everytime!
      options = {}
      options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
      options[:body] = {client_id: ENV["MEETUP_KEY"], client_secret: ENV["MEETUP_SECRET"], grant_type: "refresh_token", refresh_token: current_user.refresh_token}
      data = HTTParty.post("https://secure.meetup.com/oauth2/access", options)
      byebug
      current_user.token = data["access_token"]
      current_user.refresh_token = data["refresh_token"]
      current_user.expires_at = Time.now.to_i + data["expires_in"]
    end
    return current_user.token
  end

end
