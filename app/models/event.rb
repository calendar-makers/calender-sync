class Event < ActiveRecord::Base
  has_many :guests, through: :registrations
  has_many :registrations

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

  def is_new?
    Event.find_by_meetup_id(meetup_id).nil?
  end

  def is_updated?(latest_update)
    updated < latest_update
  end

  def count_event_participants
    regis = self.registrations
    sum = 0
    regis.each do |reg|
      sum += 1 + reg.invited_guests
    end
    sum
  end

  def generate_participants_message
    "The total number of participants, including invited guests, so far is:
     #{self.count_event_participants}"
  end
end
