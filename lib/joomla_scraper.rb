require 'singleton'

class JoomlaScraper
  include Singleton

  HOST_WEBSITE = 'http://www.natureinthecity.org'

  def preprocess_css
    css_base
    css_image
    css_script
    css_li
    css_a_form_link
  end

  def css_base
    @page.css('base').each do |tag|
      tag.remove
    end
  end

  def css_handler(group_elem, elem, condition )
    @page.css(group_elem).each do |tag|
      selector = tag[elem]
      tag.set_attribute(elem, HOST_WEBSITE + selector) if condition.call(selector)
    end
  end

  def css_image
    css_handler('img', 'src', lambda {|elem| !elem.nil? && elem[0] == '/'})
  end

  def css_a_form_link
    css_handler('a,form,link', 'href', lambda {|elem| !elem.nil? && elem[0] == '/'})
  end

  def css_script
    css_handler('script', 'src', lambda {|elem| !elem.nil? && elem.match('/media')})
  end

  def css_li
    @page.css('li').each do |tag|
      css_class = tag['class']
      tag['class'] = 'item-144 current' if !css_class.nil? and css_class == 'item-144'
    end
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

  def scrape_data
    preprocess_css
    @head = @page.at_css("head").inner_html
    @header = @page.at_css "header"
    @footer = @page.at_css "footer"
    @section = @page.css('#gk-bottom')
  end

  def joomla_data
    [@head, @header, @footer, @section]
  end
end