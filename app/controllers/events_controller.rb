class EventsController < ActionController::Base

  def index
    @events = Event.all
    @message = flash[:notice]
  end

  def show
    @event = Event.find params[:id]

    new_guests = merge_meetup_rsvps(@event)

    if new_guests.nil?
      # FOR THE MOMENT ANY LOCAL ONLY EVENT WILL SHOW WITH THIS MESSAGE
      # Once event pushing is done then it won't
      flash[:notice] = "Could not merge RSVP list for this event."
    elsif new_guests.empty?
      flash[:notice] = "The RSVP list is synched with Meetup. #{@event.generate_participants_message}."
    else
      flash[:notice] = "The RSVP list for this event has been updated.
        #{new_guests.join(', ')} #{(new_guests.size > 1 ? "have" : "has")} joined.
        #{@event.generate_participants_message}"
    end
  end


  # Non-nil returned output is always valid
  def get_remote_rsvps(event)
    # Could pass arguments to constructor to refine search
    meetup = Meetup.new
    meetup.pull_rsvps(event.meetup_id)
  end


  def merge_meetup_rsvps(event)
    rsvps = get_remote_rsvps(event)

    if rsvps
      new_guest_names = []
      rsvps.each do |rsvp|

        guest = Guest::find_guest_by_meetup_rsvp(rsvp) || Guest::create_guest_by_meetup_rsvp(rsvp)

        registration = Registration.find_by({event_id: event.id, guest_id: guest.id})
        if registration.nil?
          Registration.create!(event_id: event.id, guest_id: guest.id,
                               invited_guests: rsvp[:invited_guests],
                               updated: rsvp[:updated])
        elsif registration.is_updated?(rsvp[:updated])
          registration.update_attributes!(invited_guests: rsvp[:invited_guests],
                                          updated: rsvp[:updated])
        else # neither new nor updated
          next
        end

        new_guest_names << guest.first_name + (' ' if guest.last_name) + guest.last_name
      end

      new_guest_names
    end
  end





  def new
    if flash[:notice] == nil
      @message = ""
    else
      @message = "Please fill in the following fields before submitting: "
      flash[:notice].each do |key|
        @message += key + ", "
      end
    end
    @message = @message[0..@message.length-3]
  end

  def create
    result = Event.check_if_fields_valid(event_params)
    if !result[:value]
      flash[:notice] = result[:message]
      redirect_to new_event_path
      return
    end
    @event = Event.create!(event_params)
    params[:event] = @event
    flash[:notice] = "\"#{@event.name}\" was successfully added."
    redirect_to events_path
  end

  def edit
    if !flash[:notice].is_a?(Array)
      @message = ""
    else
      @message = "Please fill in the following fields before submitting: "
      flash[:notice].each do |key|
        @message += key + ", "
      end
    end
    @message = @message[0..@message.length-3]

    #begin
    @event = Event.find params[:id]
    #rescue ActiveRecord::RecordNotFound
    #  flash[:notice] = "404: This is not the event you are looking for."
    #  redirect_to events_path
    #end
  end

  def update
    @event = Event.find params[:id]
    result = Event.check_if_fields_valid(event_params)
    if !result[:value]
      flash[:notice] = result[:message]
      redirect_to edit_event_path(@event)
      return
    end
    @event.update_attributes!(event_params)
    flash[:notice] = "\"#{@event.name}\" was successfully updated."
    redirect_to event_path(@event)
  end

  def destroy
    @event = Event.find params[:id]
    @event.destroy
    flash[:notice] = "\"#{@event.name}\" was successfully removed."
    redirect_to events_path
  end

  private

  #Never trust anything from the internet
  def event_params
    params.require(:event).permit(:name, :organization,
                                  :start, :location,
                                  :description)
  end
end
