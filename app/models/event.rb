class Event < ActiveRecord::Base
  def Event.get_organization_events(org)
  	Event.where(organization: org)
  end
  def Event.get_events_for_month(month = 03, year = 2015)
  	Event.where(date: (year.to_s+"-0"+month.to_s+"-01")..(year.to_s+"-0"+month.to_s+"-01") )
  end
  def Event.get_event_for_day(day, month, year)
  	day = '0'+day.to_s if day.to_s.lenght < 2
  	month = '0'+month.to_s if month.to_s.lenght <2
  	year = year.to_s
  	Event.where(date: "#{year}-#{month}-#{day}" )
  end
  def formatted_date
    date.strftime('%B %d, %Y')
  end

  def formatted_time
    time.strftime('%l:%M%P')
  end

end
