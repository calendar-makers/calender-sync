require 'singleton'

class WebScraper
  include Singleton

  HOST_WEBSITE_URI = URI.parse 'http://natureinthecity.org'

  def get_backup
    file = File.expand_path('backup.html', File.dirname(__FILE__))
    @page = Nokogiri::HTML(File.read(file))
  end

  def fetch_page_data
    begin
      @page = Nokogiri::HTML(HOST_WEBSITE_URI.open)
    rescue StandardError
      get_backup
    end
    scrape_data
  end

  def scrape_data
    @head = @page.at_css 'head'
    @body = @page.at_css 'body'
  end

  ##
  # This method provides the squarespace data to the calendars controller
  #
  def page_data
    [@head, @body]
  end
end