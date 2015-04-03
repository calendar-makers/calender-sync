class EventsController < ActionController::Base
  def index
    @events = Event.all
    @message = flash[:notice]
    @events = Event.between(params['start'], params['end']) if (params['start'] && params['end'])
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    @message = flash[:notice]
    @event = Event.find params[:id]
    @non_anon_guests_by_last_name = @event.guests.order(:last_name).where(is_anon: false)

    new_guests = @event.merge_meetup_rsvps
    if new_guests.nil?
      # FOR THE MOMENT ANY LOCAL ONLY EVENT WILL SHOW WITH THIS MESSAGE
      # Once event pushing is done then it won't
      flash[:notice] = "Could not merge RSVP list for this event."
    elsif new_guests.empty?
      flash[:notice] = "The RSVP list is synched with Meetup. #{@event.generate_participants_message}."
    else
      flash[:notice] = "The RSVP list for this event has been updated." +
        " #{new_guests.join(', ')} #{(new_guests.size > 1 ? "have" : "has")} joined." +
        " #{@event.generate_participants_message}"
    end
  end

  # THE GOAL IS TO REUSE THESE FUNCTIONS ABOVE
  def third_party
    # Get them all by meetup id... So make a pull for each one
    # To display them get them with a generic pull by organization

    if !params[:id].blank?
      @events = Event.get_remote_events({event_id: params[:id]})
    elsif  !params[:group_urlname].blank?
      @events = Event.get_remote_events({group_urlname: params[:group_urlname]})
    else
      @events = []
    end
  end

  def pull_third_party
    ids = EventsController.get_requested_ids(params)
    if ids.size > 0
      ids = EventsController.cleanup_ids(ids)
      options = {event_id: ids.join(',')}
      event_names = Event.make_events_local(Event.get_remote_events(options))
      flash[:notice] = event_names
    else
      flash[:notice] = 'You must select at least one event. Please retry.'
    end

    redirect_to calendar_path
  end

  def self.get_requested_ids(data)
    data.keys.select {|k| k =~ /^event.+$/}
  end

  def self.cleanup_ids(ids)
    clean_ids = []
    ids.each {|id| clean_ids << id.gsub("event", "")}
    clean_ids
  end


  def new
    form_validation_msg
  end

  def create
    result = Event.check_if_fields_valid(event_params)
    if !result[:value]
      flash[:notice] = result[:message]
      redirect_to new_event_path
      return
    end
    # meetup push support
    # meetup = Meetup.new
    # meetup.push_event(event_params) # DOES NOT WORK, no param validation atm
    @event = Event.create!(event_params)
    params[:event] = @event
    flash[:notice] = "\"#{@event.name}\" was successfully added."
    redirect_to calendar_path
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
    redirect_to calendar_path
  end

  def destroy
    @event = Event.find params[:id]
    @event.destroy
    flash[:notice] = "\"#{@event.name}\" was successfully removed."
    redirect_to calendar_path
  end

  private

  #Never trust anything from the internet
  def event_params
    params.require(:event).permit(:name, :organization,
                                  :start, :location,
                                  :description, :image)
  end

  def form_validation_msg
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
end
