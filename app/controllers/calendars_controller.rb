class CalendarsController < ApplicationController

  def show
    # For the moment keep running this task at every page view.
    # But later I should switch to a scheduler (the link is on the browser)

    if flash[:notice].nil? && flash[:warning].nil? # this is a hack to guarantee I can see any flash coming in
      event_names = Event.make_events_local(Event.get_remote_events)
      if event_names.nil?
        flash[:notice] = "Could not pull events from Meetup"
      elsif event_names.empty?
        flash[:notice] = "The Calendar and Meetup are synched"
      else
        flash[:notice] = "Successfully pulled events: #{event_names.join(', ')}"
      end
    end
  end
end

