class Event < ActiveRecord::Base
  def self.events_for_month(month, year)
    year2 = year
    month2 = month + 1
    if month == 12
      month2 = 1
      year2 = year + 1
    end
    #Event.where(start: (year.to_s + '0' + month.to_s)
  end

  def self.check_if_fields_valid(arg1)
    result = {}
    result[:message] = []
    result[:value] = true
    arg1.each do |k, v|
      if v == nil || v == ''
        result[:value] = false
        result[:message].append k.to_s
      end
    end
    result
  end
end
