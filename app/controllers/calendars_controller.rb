class CalendarsController < ApplicationController
  def show
    # For the moment keep running this task at every page view.
    # But later I should switch to a scheduler (the link is on the browser)

    @date = '2014-05-01'

    # all for the panel...
    @event = Event.find(1);
    @when = @event.start.strftime("%a, %b %-d, %Y at %l:%M %P") + " to (infinity and beyond...)"

    if flash[:notice].nil? # For the moment prevent all of this if a message came in
      events = Event.make_events_local(Event.get_remote_events)

      if events.nil?
        flash[:notice] = "Could not pull events from Meetup"
      elsif events.empty?
        flash[:notice] = "The Calendar and Meetup are synched"
      else
        #flash[:notice] = ['Successfully pulled events: '] + CalendarsController.get_event_info(events)
        flash[:notice] = 'Successfully pulled events: ' + CalendarsController.get_event_info(events)
      end
    end
  end

  def self.get_event_info(events)
    info = []
    events.each {|event| info << event[:name]}
    info.join(', ')
  end
end
