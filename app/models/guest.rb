class Guest < ActiveRecord::Base
  has_many :registrations
  has_many :events, through: :registrations
  has_many :registrations

  def self.fields_valid?(fields)
    fields.each do |k, v|
      if v == nil || v == ''
        return false
      end
    end
    true
  end

  # Best effort. Meetup names have no specific format
  def self.parse_meetup_name(name)
    name.strip!
    if name.include?(" ")
      return name.split(" ")
    else
      return name, ""
    end
  end

  def self.find_guest_by_meetup_rsvp(rsvp)
    Guest.find_by_meetup_id(rsvp[:meetup_id])
  end

  def self.create_guest_by_meetup_rsvp(rsvp)
    first, last = Guest::parse_meetup_name(rsvp[:meetup_name])
    Guest.create!(first_name: first, last_name: last,
                  is_anon: false, meetup_id: rsvp[:meetup_id])
  end
end
