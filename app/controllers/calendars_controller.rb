class CalendarsController < ApplicationController

  def show
    # For the moment keep running this task at every page view.
    # But later I should switch to a scheduler (the link is on the browser)

    if flash[:notice].nil? # For the moment prevent all of this if a message came in
      events = Event.make_events_local(Event.get_remote_events)

      if events.nil?
        flash[:notice] = "Could not pull events from Meetup"
      elsif events.empty?
        flash[:notice] = "The Calendar and Meetup are synched"
      else
        byebug
        flash[:notice] = ['Successfully pulled events: '] + events.each {|event| [event[:name], event[:url]]}
      end
    end
  end
end

