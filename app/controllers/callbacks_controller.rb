class CallbacksController < Devise:: OmniauthCallbacksController
  def meetup
    auth = request.env["omniauth.auth"]
    @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || 
      User.create_with_omniauth(auth)
    sign_in_and_redirect @user
  end

  def failure
    flash[:notice] = "Failed to login..."
    @message = flash[:notice]
    redirect_to '/'
  end
end
