class CalendarsController < ApplicationController
  include JoomlaScraper

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def show
    fetch_joomla_data
  end
end
