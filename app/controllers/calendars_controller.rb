class CalendarsController < ApplicationController

  def preprocess_header_footer
    @page.css("base").each do |tag|
      tag.remove()
    end
    @page.css("li").each do |tag|
      if tag["class"] != nil and tag["class"] =="item-144"
        tag["class"] = "item-144 current"
      end
    end
    @page.css("a,form").each do |tag|
      if tag["href"] !=nil and tag["href"][0] =='/'
        tag.set_attribute('href', "http://www.natureinthecity.org" + tag["href"])
      end
    end
    @section =""
    @page.css("section").each do |elem|
      if elem["id"] == "gk-bottom"
        @section = elem
      end
    end
    @head1 = @page.at_css "head"
    @header = @page.at_css "header"
    @footer = @page.at_css "footer"
  end

  def show
    # For the moment keep running this task at every page view.
    # But later I should switch to a scheduler (the link is on the browser)
    begin
      @page = Nokogiri::HTML(open("http://www.natureinthecity.org/"))
      @neededRescue = false
    rescue SocketError
      puts "***************************************"
      @neededRescue = true
    end
    if !@neededRescue
      preprocess_header_footer
    end
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
