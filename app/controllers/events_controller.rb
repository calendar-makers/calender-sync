class EventsController < ActionController::Base
  def index
    @events = Event.all
    @message = flash[:notice]
  end

  def show
#    begin
    @event = Event.find params[:id]
#    rescue ActiveRecord::RecordNotFound
#      flash[:notice] = "404: This is not the event you are looking for."
#      redirect_to events_path
#    end
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
