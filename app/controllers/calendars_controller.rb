class CalendarsController < ApplicationController
  def show
    if flash[:notice].nil? # Prevent Meetup synchronization if have incoming message
      events = Event.make_events_local(Event.get_remote_events)
      display_synchronization_result(events)
    end
  end

  def display_synchronization_result(events)
    if events.nil?
      flash.now.notice = "Could not pull events from Meetup"
    elsif events.empty?
      flash.now.notice = "The Calendar and Meetup are synched"
    else
      flash.now.notice = 'Successfully pulled events: ' + CalendarsController.get_event_info(events) + ' from Meetup'
    end
  end

  def self.get_event_info(events)
    info = []
    if events.size < 30
      events.each {|event| info << event[:name]}
    else
      events[0..30].each {|event| info << event[:name]}
      info << 'and more'
    end
    info.join(', ')
  end
end
