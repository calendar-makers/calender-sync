class EventsController < ApplicationController
  #before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :third_party]

  before_filter :check_for_cancel, :only => [:create, :update]

  def check_for_cancel
    if params[:cancel]
      render 'default', format: :js
    end
  end

  def index
    start_date = params[:start]
    end_date = params[:end]
    @events = (start_date && end_date) ? Event.where(start: start_date.to_datetime..end_date.to_datetime) : Event.all
    respond_to do |format|
      format.html
      format.json { render :json => @events }
    end
  end

  def show
    begin
      byebug
      @event = Event.find params[:id]
      @time_period = @event.format_time
      @non_anon_guests_by_first_name = @event.guests.order(:first_name).where(is_anon: false)
      @event.merge_meetup_rsvps
      respond_do
    rescue Exception => e
      @msg = "Could not pull rsvps '#{@event.name}':" + '\n' + e.to_s
      render 'errors', format: :js
    end

  end

  #########################################################
  ############  UNPROTECTED BY RESCUE CLAUSE ##############
  ############  This code must first be changed to implement javascript 3rd party implementation

  def third_party
    id = params[:id]
    if id.present?
      @events = Event.get_remote_events({event_id: id})
      #return respond_do
    end
    return respond_do

    #######################################
=begin
    id = params[:id]
    return @events = Event.get_remote_events({event_id: id}) unless id.blank?
    group_urlname = params[:group_urlname]
    return @events = Event.get_remote_events({group_urlname: group_urlname}) unless group_urlname.blank?
    @events = []
=end
  end

  def pull_third_party
    ids = Event.get_event_ids(params)
    if ids.blank?
      @msg = 'You must select at least one event. Please retry.'
      #return redirect_to third_party_events_path
    end
    Event.store_third_party_events(ids)

    render partial: 'pull_third_party', format: :js

    #########################################
=begin
    ids = Event.get_event_ids(params)
    if ids.blank?
      flash[:notice] = 'You must select at least one event. Please retry.'
      return redirect_to third_party_events_path
    end
    events = Event.store_third_party_events(ids)
    redirect_to calendar_path
=end
  end
  ###########################################################
  ###########################################################

  def run_rsvp_update(event)
    Thread.new do
      event.merge_meetup_rsvps
    end
  end

  def new
    respond_do
  end

  # handles panel add new event
  def create
    perform_create_transaction
    @success ? respond_do : (render 'errors', format: :js)
  end

  def perform_create_transaction
    begin
      @event = Event.new(event_params)
      remote_event = Meetup.new.push_event(@event)
      @event.update_meetup_fields(remote_event)
      @event.save!
      @success = true
      @msg = "Successfully added '#{@event.name}'!"
    rescue Exception => e
      @msg = "Could not create '#{@event.name}':" + '\n' + e.to_s
    end
  end

  def edit
    @event = Event.find params[:id]
    respond_do
  end

  # does panel update event
  def update
    @event = Event.find params[:id]
    if @event.is_third_party? || @event.is_past?
      @msg = "Sorry but third-party and past events cannot be edited. Only deleted."
    else
      perform_update_transaction
    end
    @success ? respond_do : (render 'errors', format: :js)
  end

  def perform_update_transaction
    event = Event.new(event_params)
    begin
      remote_event = Meetup.new.edit_event({event: event, id: @event.meetup_id})
      @event.update_attributes(event_params)
      @event.update_attributes(venue_name: remote_event[:venue_name])  # Necessary if meetup refused to create the venue
      @success = true
      @msg = "#{@event.name} successfully updated!"
    rescue Exception => e
      @msg = "Could not update '#{@event.name}':" + '\n' + e.to_s
    end
  end

  # handles panel event delete
  def destroy
    @event = Event.find params[:id]
    @id = @event.id
    perform_destroy_transaction
    @success ? respond_do : (render 'errors', format: :js)
  end

  def perform_destroy_transaction
    begin
    if @event.is_third_party? || Meetup.new.delete_event(@event.meetup_id)
      @event.destroy
      @success = true
      @msg = "#{@event.name} event successfully deleted!"
    end
    rescue Exception => e
      @msg = "Failed to delete event '#{@event.name}':" + '\n' + e.to_s
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
    params.require(:event).permit(:name, :organization, :venue_name, :st_number, :st_name, :city, :zip,
                                  :state, :country, :start, :end, :description, :how_to_find_us, :image,
                                  :street_number, :route, :locality)
  end
end
