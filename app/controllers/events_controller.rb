class EventsController < ActionController::Base

  def all_events
    @events = Event.all
  end

  def event_details
    #byebug
    @event = Event.find(params[:id])
  end

  private
  def event_params
    params.require(:event).permit(:organization, :name, :date, :time, :location, :description)
  end

end