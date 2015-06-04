module JoomlaScraper

  HOST_WEBSITE = 'http://www.natureinthecity.org'

  def scrape_data
    @head = @page.at_css("head").inner_html
    @header = @page.at_css "header"
    @footer = @page.at_css "footer"
    @section = @page.css('#gk-bottom')
  end

  def get_backup
    file = File.join(Rails.root, 'features', 'support', 'backup.html')
    @page = Nokogiri::HTML(File.read(file))
  end

  def fetch_joomla_data
    begin
      @page = Nokogiri::HTML(open(HOST_WEBSITE))
    rescue Exception
      get_backup
    end
    scrape_data
  end
end