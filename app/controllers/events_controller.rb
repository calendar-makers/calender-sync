def printer(arg1)
  puts "******** LOG *********"
  puts arg1.inspect
  puts "******** END *********"
end

class EventsController < ActionController::Base
  def index
    @events = Event.all
  end

  def show
    begin
      @event = Event.find params[:id]
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "404: This is not the event you are looking for."
      redirect_to events_path
    end
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
    begin
      @event = Event.find params[:id]
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "404: This is not the event you are looking for."
      redirect_to events_path
    end
  end

  def update
    @event = Event.find params[:id]
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
                                  :date, :time,
                                  :location, :description)
  end
end
