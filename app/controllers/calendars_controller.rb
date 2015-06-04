class CalendarsController < ApplicationController

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def show
    @head, @header, @footer, @section = JoomlaScraper.instance.joomla_data
  end
end
