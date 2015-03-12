def printer(arg1)
  puts "******** LOG *********"
  puts arg1.inspect
  puts "******** END *********"
end

class EventsController < ActionController::Base
  def index
    @message = flash[:notice]
    @events = Event.last(3)
    @month  = Month.new

    @var = Event.get_events_for_month(4,2015)
    printer(@var)
  end

  def show
    @event = Event.find params[:id]
  end

  def new
    # default: render 'new' template
    printer("I'm in new")
  end

  def create
    @event = Event.create!(event_params)
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

  #Never trust anything from the internet
  def event_params
    params.require(:event).permit(:name, :organization,
                                  :date, :time,
                                  :location, :description)
  end
end
