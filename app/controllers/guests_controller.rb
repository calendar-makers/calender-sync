class GuestsController < ActionController::Base
  def create
    @event = Event.find(params[:event_id])
    if !Guest.fields_valid?(guest_params)
      return redirect_to event_path(@event.id), notice: 'Please fill out all fields to RSVP.'
    end
    handle_guest_registration
  end

  def handle_guest_registration
    @guest = Guest.find_by_email(guest_params[:email]) || Guest.create!(guest_params)
    if @guest.events.include?(@event)
      redirect_to event_path(@event.id), notice: "#{@guest.email} is already registered for this event!"
    else
      @guest.registrations.build({:event_id => params[:event_id], :guest_id => @guest.id})
      @guest.save
      redirect_to event_path(@event.id), notice: "You successfully registered for this event!"
    end
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name, :phone, :email, :address, :is_anon)
  end
end
