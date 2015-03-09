class Event < ActiveRecord::Base
  #:organization, :name, :date, :time, :description, :location

  def get_time
    self.time.strftime("%l:%M%P")
  end


  def get_date
    self.date.strftime("%B %d, %Y")
  end

end