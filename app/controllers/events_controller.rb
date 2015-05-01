class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :third_party]
  def printer tag = "N/A", arg1 
    puts "********** "+tag+" ***********"
    puts "=> " + arg1.inspect
    puts "********** END ****************"
  end
  def index
    @message = flash[:notice]
    start_date = params[:start]
    end_date = params[:end]
    @events = (start_date && end_date) ? Event.between(start_date, end_date) : Event.all
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    @message = flash[:notice]
    @event = Event.find params[:id]

    startTime = @event.start.strftime('%b %e, %Y at %l:%M %P')
    endTime = ""
    if @event.end
      if (@event.end - @event.start) >= 1
        endTime = @event.end.strftime('%b %e, %Y at %l:%M %P')
      else
        endTime = @event.end.strftime('%l:%M %P')
      end
    end
    @timePeriod = startTime
    @timePeriod = startTime + ' to ' + endTime unless endTime == ""

    new_guests = @event.merge_meetup_rsvps
    @non_anon_guests_by_first_name = @event.guests.order(:first_name).where(is_anon: false)
    display_synchronization_result(new_guests)
    @refresh = 1


  end

  def display_synchronization_result(new_guests)
    if new_guests.nil?
      flash.now.notice = 'Could not merge the RSVP list for this event.'
    elsif new_guests.empty?
      flash.now.notice = "The RSVP list is synched with Meetup. #{@event.generate_participants_message}."
    else
      flash.now.notice = 'The RSVP list for this event has been updated.' \
        " #{new_guests.join(', ')} #{(new_guests.size > 1 ? "have" : "has")} joined." \
        " #{@event.generate_participants_message}."
    end
  end

  def third_party
    if not params[:id].blank?
      @events = Event.get_remote_events({event_id: params[:id]})
    elsif  !params[:group_urlname].blank?
      @events = Event.get_remote_events({group_urlname: params[:group_urlname]})
    else
      @events = []
    end
  end

  def pull_third_party
    ids = Event.get_event_ids(params)
    if ids.blank?
      flash[:notice] = 'You must select at least one event. Please retry.'
      return redirect_to third_party_events_path
    end
    events = Event.store_third_party_events(ids)
    redirect_to calendar_path, notice: Event.display_message(events)
  end

  def new
    @refresh = 0
    form_validation_msg
  end

  def create
    @refresh = 0
    tag = "create"
    printer tag, "start"
    result = Event.check_if_fields_valid(event_params)
    return redirect_to new_event_path, notice: "Please fill in the following fields: " + result[:message].to_s if not result[:value]
    perform_create_transaction
    printer tag, "after preform create transaction"
    respond_to do |format|
      format.html { render :nothing => true }
      format.json { render :nothing => true }
    end
  end

  def perform_create_transaction
    tag = "perform_create_transaction"
    printer tag, "start"
    @event = Event.new(event_params)
    remote_event = Meetup.new.push_event(@event)
    printer tag, "after Meetup push"
    printer tag+" remote_event", remote_event 
    if remote_event
      printer tag, "if"
      @event.update_meetup_fields(remote_event)
      @event.save!
      flash[:notice] = "'#{@event.name}' was successfully added and pushed to Meetup."
      #$('#refresh').attr("id", "refresh active")
      #@refresh = 1
      #render js: "console.log('Im here Im here Im here!');"
      #respond_to do |format|
      #  format.js
      #end

    else
      printer tag, "else"
      flash[:notice] = "Failed to push event '#{@event.name}' to Meetup. Creation aborted."
    end
  end

  def edit
    form_validation_msg
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find params[:id]
    result = Event.check_if_fields_valid(event_params)
    return redirect_to edit_event_path(@event), notice: result[:message] if not result[:value]
    perform_update_transaction
    respond_to do |format|
      format.html { redirect_to calendar_path }
      format.json { render :nothing => true }
    end
  end

  def perform_update_transaction
    if Meetup.new.edit_event(updated_fields: event_params, id: @event.meetup_id)
      @event.update_attributes(event_params)
      flash[:notice] = "'#{@event.name}' was successfully updated."
    else
      flash[:notice] = "Could not update '#{@event.name}'."
    end
  end

  def destroy
    @event = Event.find params[:id]
    perform_destroy_transaction
    redirect_to calendar_path
    #render :nothing => true
  end

  def perform_destroy_transaction
    if Meetup.new.delete_event(@event.meetup_id)
      @event.destroy
      flash[:notice] = "'#{@event.name}' was successfully removed from the Calendar and from Meetup."
    else
      flash[:notice] = "Failed to delete event '#{@event.name}' from Meetup. Deletion aborted."
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :organization, :venue_name, :address_1,
                                  :city, :zip, :state, :country, :start, :end,
                                  :description, :how_to_find_us, :image)
  end

  def form_validation_msg
    @message = flash[:notice] || ''
    if flash[:notice].respond_to? :join
      @message = 'Please fill in the following fields before submitting: ' + flash[:notice].join(', ')
    end
  end
end
