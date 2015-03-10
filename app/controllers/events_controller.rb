class EventsController < ActionController::Base

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  private
  def event_params
    params.require(:event).permit(:name, :organization, :date, :time, :location, :description)
  end

end
