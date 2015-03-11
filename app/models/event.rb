class Event < ActiveRecord::Base
  #:name, :organization, :description, :date, :time, :location

  def formatted_date
    date.strftime('%B %d, %Y')
  end

  def formatted_time
    time.strftime('%l:%M%P')
  end
end
