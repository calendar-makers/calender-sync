module CalendarsHelper
  def process_body(body)
    replace_wrapper(body)
    insert_calendar(body)
    replace_image(body)
    raw body
  end

  def replace_wrapper(body)
    square_space_wrapper = render 'shared/squarespace_wrapper'
    elem = body.at_css('#page').first_element_child
    elem.replace square_space_wrapper
  end

  def insert_calendar(body)
    calendar = render 'calendar'
    elem = body.at_css('#block-yui_3_17_2_6_1436507156755_8418 .sqs-block-content')
    elem.add_child calendar
  end

  def replace_image(body)
    square_space_image = render 'shared/squarespace_image'
    elem = body.at_css('#hero')
    elem.replace square_space_image
  end

  def process_head(head)
    head.at_css('title').content = 'Calendar — Nature in the City'
    raw head
  end
end