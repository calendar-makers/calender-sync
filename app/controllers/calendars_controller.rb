class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def show
<<<<<<< HEAD
=======
    @tabs = %w(Upcoming Pending Rejected Past)
    @pending_count = Event.get_pending_events.count
    @pending = Event.get_pending_events
    @upcoming = Event.where(:status => 'upcoming')
    @past = Event.where(:status => 'past')
    @rejected = Event.get_rejected_events
>>>>>>> stuff
    @head, @body = WebScraper.instance.page_data
  end
end
