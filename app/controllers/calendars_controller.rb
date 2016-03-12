class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def show
<<<<<<< HEAD
<<<<<<< HEAD
=======
    @tabs = %w(Upcoming Pending Rejected Past)
    @pending_count = Event.get_pending_events.count
    @pending = Event.get_pending_events
    @upcoming = Event.where(:status => 'upcoming')
    @past = Event.where(:status => 'past')
    @rejected = Event.get_rejected_events
>>>>>>> stuff
=======
    @pending = 1
>>>>>>> fdbd89ca5fe448b4cc11730e7a9c734c34318f36
    @head, @body = WebScraper.instance.page_data
  end
end
