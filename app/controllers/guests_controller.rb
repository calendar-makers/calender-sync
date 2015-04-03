<<<<<<< HEAD
class GuestsController < ActionController::Base
  def create
    event = Event.find(params[:event_id])
    if !Guest.fields_valid?(guest_params)
      flash[:notice] = "Please fill out all fields to RSVP."
      redirect_to event_path(event.id)
      return
    end
    @guest = Guest.create!(guest_params)
    params[:guest] = @guest
    flash[:notice] = "You successfully registered for this event!"

    registration = @guest.registrations.build({:event_id => params[:event_id], :guest_id => @guest.id})
    @guest.save

    redirect_to event_path(event.id)
  end

  private

  def guest_params
    params.require(:guest).permit(:first_name, :last_name,
                                  :phone, :email,
                                  :address, :is_anon)
  end
=======
class GuestsController < ApplicationController
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
end
