class GuestsController < ActionController::Base
  def create
    event = Event.find(params[:event_id])
    if !Guest.fields_valid?(guest_params)
      flash[:notice] = "Please fill out all fields to RSVP."
      redirect_to event_path(event.id)
      return
    end

    @guest = Guest.find_by_email(guest_params[:email]) || Guest.create!(guest_params)
    if @guest.events.include?(event)
      flash[:notice] = "#{@guest.email} is already registered for this event!"
    else
      params[:guest] = @guest
      flash[:notice] = "You successfully registered for this event!"
      registration = @guest.registrations.build({:event_id => params[:event_id], :guest_id => @guest.id})
      @guest.save
    end
    redirect_to event_path(event.id)
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name,
                                  :phone, :email,
                                  :address, :is_anon)
  end
end
