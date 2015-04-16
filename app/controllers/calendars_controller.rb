class CalendarsController < ApplicationController
  def printer(arg)
    puts "**********************"
    puts "=> " + arg.inspect
    puts "**********************"
  end

  def show
    # For the moment keep running this task at every page view.
    # But later I should switch to a scheduler (the link is on the browser)
    @page = Nokogiri::HTML(open("http://www.natureinthecity.org/"))

    @page.css("form").each do |tag|
      if tag["href"] != nil and tag["href"][0] =='/'
        tag.set_attribute('href', "http://www.natureinthecity.org" + tag["href"])
      end
    end

    @page.css("a").each do |tag|
      if tag["href"][0] =='/'
        tag.set_attribute('href', "http://www.natureinthecity.org" + tag["href"])
      end
    end
    @head1 = @page.at_css "head"
    @header = @page.at_css "header"

    if flash[:notice].nil? # For the moment prevent all of this if a message came in
      events = Event.make_events_local(Event.get_remote_events)

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
