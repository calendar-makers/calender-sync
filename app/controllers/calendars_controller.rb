class CalendarsController < ApplicationController
  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def preprocess_header_footer
    css_base
    css_image
    css_script
    css_li
    css_a_form_link
    css_section
    @head1 = (@page.at_css "head").inner_html
    @header = @page.at_css "header"
    @footer = @page.at_css "footer"
  end

  def css_base
    @page.css("base").each do |tag|
      tag.remove()
    end
  end

  def css_image
    @page.css("img").each do |tag|
      if tag["src"]!=nil and tag["src"][0]=='/'
        tag.set_attribute('src', 'http://www.natureinthecity.org' + tag["src"])
      end
    end
  end

  def css_script
    @page.css("script").each do |tag|
      if tag["src"]!=nil and tag["src"].match('/media')
        tag.set_attribute('src', 'http://www.natureinthecity.org' + tag["src"])
      end
    end
  end

  def css_li
     @page.css("li").each do |tag|
      if tag["class"] != nil and tag["class"] =="item-144"
        tag["class"] = "item-144 current"
      end
    end
  end

  def css_a_form_link
    @page.css("a,form,link").each do |tag|
      if tag["href"] !=nil and tag["href"][0] =='/'
        tag.set_attribute('href', "http://www.natureinthecity.org" + tag["href"])
      end
    end
  end

  def css_section
    @section =""
    @page.css("section").each do |elem|
      if elem["id"] == "gk-bottom"
        @section = elem
      end
    end
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
      events = Event.synchronize_upcoming_events
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
