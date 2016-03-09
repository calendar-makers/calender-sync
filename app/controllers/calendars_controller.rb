class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def show
    @pending = 1
    @head, @body = WebScraper.instance.page_data
  end
end
