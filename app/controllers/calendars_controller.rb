class CalendarsController < ApplicationController
  def show
    # For the moment keep running this task at every page view.
    # But later I should switch to a scheduler (the link is on the browser)

    @datetime = '2014-05-01 03:00pm'

    if flash[:notice].nil? # For the moment prevent all of this if a message came in
      events = Event.make_events_local(Event.get_remote_events)

      ## CHECK FOR DELETION and do if needed
      # Pluck the list of meetup_ids from database and compare with list of meetup_ids in events
      # The difference (literally subtraction) at this point (i.e. after creation of new ones... will be in need of deletion)

      if events.nil?
        flash.now.notice = "Could not pull events from Meetup"
      elsif events.empty?
        flash.now.notice = "The Calendar and Meetup are synched"
      else
        flash.now.notice = 'Successfully pulled events: ' + CalendarsController.get_event_info(events) + ' from Meetup'
      end
    end
  end

  def self.get_event_info(events)
    info = []
    events.each {|event| info << event[:name]}
    info.join(', ')
  end
end
