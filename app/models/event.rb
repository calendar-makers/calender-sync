class Event < ActiveRecord::Base
  def Event.get_organization_events(org)
  	Event.where(organization: org)
  end
  def Event.get_events_for_month(month = 03, year = 2015)
  	Event.where(date: (year.to_s+"-0"+month.to_s+"-01")..(year.to_s+"-0"+((month%12)+1).to_s+"-01") )
  end
  #def Event.get_event_for_day(day)
  def formatted_date
    date.strftime('%B %d, %Y')
  end

  def formatted_time
    time.strftime('%l:%M%P')
  end

end
