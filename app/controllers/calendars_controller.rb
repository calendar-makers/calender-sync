class CalendarsController < ApplicationController
  HOST_WEBSITE = 'http://www.natureinthecity.org'

  before_filter do
    if request.ssl? && Rails.env.production?
      redirect_to :protocol => 'http://', :status => :moved_permanently
    end
  end

  def preprocess_header_footer
    preprocess_css
    @head = @page.at_css("head").inner_html
    @header = @page.at_css "header"
    @footer = @page.at_css "footer"
  end

  def preprocess_css
    css_base
    css_image
    css_script
    css_li
    css_a_form_link
    css_section
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

  def css_section
    @section =''
    @page.css('section').each do |elem|
      @section = elem if elem['id'] == 'gk-bottom'
    end
  end

  def preprocess_for_bad_request
    file = File.join(Rails.root, 'features', 'support', 'backup.html')
    @page = Nokogiri::HTML(File.read(file))
  end

  def handle_joomla
    begin
      @page = Nokogiri::HTML(open(HOST_WEBSITE))
    rescue Exception
      preprocess_for_bad_request
    end
    preprocess_header_footer
  end

  def show
    handle_joomla
    Event.synchronize_upcoming_events
  end

end
