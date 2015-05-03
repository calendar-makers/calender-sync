class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :third_party]

  def index
    start_date = params[:start]
    end_date = params[:end]
    @events = (start_date && end_date) ? Event.between(start_date, end_date) : Event.all
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    @event = Event.find params[:id]
    @time_period = Event.format_time(@event)
    new_guests = @event.merge_meetup_rsvps
    @non_anon_guests_by_first_name = @event.guests.order(:first_name).where(is_anon: false)
    respond_do
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
    respond_do
  end

  # handles panel add new event
  def create
    if not Event.fields_valid?(event_params)
      @msg = "Could not create the event. Please make sure all fields are filled before submitting."
    else
      perform_create_transaction
    end
    respond_do
  end

  def perform_create_transaction
    @event = Event.new(event_params)
    remote_event = Meetup.new.push_event(@event)
    if remote_event
      @event.update_meetup_fields(remote_event)
      @event.save!
      @msg = "Successfully added #{@event.name}!"
    else
      @msg = "Failed to push event '#{@event.name}' to Meetup. Creation aborted."
    end
  end

  def edit
    @event = Event.find params[:id]
    respond_do
  end

  # does panel update event
  def update
    @event = Event.find params[:id]
    if not Event.fields_valid?(event_params)
      @msg = "Could not update '#{@event.name}'. Please make sure all fields are filled before submitting."
    else
      perform_update_transaction
    end
    respond_do
  end

  def perform_update_transaction
    updated_fields = Event.new(event_params).updated_fields
    if Meetup.new.edit_event(updated_fields: updated_fields, id: @event.meetup_id)
      @event.update_attributes(updated_fields)
      @msg = "#{@event.name} successfully updated!"
    else
      @msg = "Could not update '#{@event.name}'."
    end
  end

  # handles panel event delete
  def destroy
    @event = Event.find params[:id]
    name = @event.name
    @id = @event.id
    perform_destroy_transaction
    respond_do
  end

  def perform_destroy_transaction
    if @event.is_third_party? || Meetup.new.delete_event(@event.meetup_id)
      @event.destroy
      @msg = "#{@event.name} event successfully deleted!"
    else
      @msg = "Failed to delete event '#{@event.name}' from Meetup. Deletion aborted."
    end
  end

  def respond_do
    respond_to do |format|
      format.html { redirect_to calendar_path }
      format.json { render :nothing => true }
      format.js
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :organization, :venue_name, :st_number, :st_name,
                                  :city, :zip, :state, :country, :start, :end,
                                  :description, :how_to_find_us, :image, :street_number, :route, :locality)
  end
end
