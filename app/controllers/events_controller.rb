class EventsController < ActionController::Base
  def index
    @events = Event.all
    @month  = Month.new
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    # default: render 'new' template
    @days = [1..31]
  end

  def create
    @event = Event.create!(param[:event])
    flash[:notice] = "\"#{@event.name}\" was successfully added."
    redirect_to events_path
  end

  def edit
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find params[:id]
    @event.update_attributes!(params[:event])
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

  def event_params
    params.require(:event).permit(:name, :organization,
                                  :date, :time,
                                  :location, :description)
  end
end
