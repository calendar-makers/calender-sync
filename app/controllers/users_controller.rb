class UsersController < ActionController::Base
  def create
    result = User.check_if_fields_valid(user_params)
    event = Event.find(params[:event_id])
    if !result[:value]
      flash[:notice] = result[:message]
      redirect_to event_path(event.id)
      return
    end
    @user = User.create!(user_params)
    params[:user] = @user
    flash[:notice] = "You successfully RSVPed!"

    registration = @user.registrations.build({:event_id => params[:event_id], :user_id => @user.id})
    @user.save

    redirect_to event_path(event.id)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name,
                                  :phone, :email,
                                  :address, :is_anon)
  end
end
