class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # force SSL so meetup redirect_url works
  force_ssl if Rails.env.production?
end
