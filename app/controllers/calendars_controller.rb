class CalendarsController < ApplicationController

  def preprocess_header_footer
    @page.css("base").each do |tag|
      tag.remove()
    end
    @page.css("img").each do |tag|
      if tag["src"]!=nil and tag["src"][0]=='/'
        tag.set_attribute('src', 'http://www.natureinthecity.org' + tag["src"])
      end
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

  def preprocess_for_bad_request
    file = File.join(Rails.root, 'features', 'support', 'backup.html')
    @page = Nokogiri::HTML(File.read(file))
  end

  def show
    begin
      @page = Nokogiri::HTML(open("http://www.natureinthecity.org/"))
    rescue Exception
      preprocess_for_bad_request
    end
    preprocess_header_footer

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
      flash.now.notice = 'Successfully pulled events: ' + self.class.get_event_info(events) + ' from Meetup'
    end
  end

  def self.get_event_info(events)
    info = []
    events.each {|event| info << event[:name]}
    info.join(', ')
  end
end
