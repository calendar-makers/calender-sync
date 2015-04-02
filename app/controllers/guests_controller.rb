class GuestsController < ActionController::Base
  def create
    result = Guest.check_if_fields_valid(guest_params)
    if !result[:value]
      flash[:notice] = result[:message]
      redirect_to show_event_path
      return
    end
    @guest = Guest.create!(guest_params)
    params[:guest] = @guest
    flash[:notice] = "You successfully RSVPed!"
    redirect_to show_event_path
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name,
                                  :phone, :email,
                                  :address, :is_anon)
  end
end
