class Guest < ActiveRecord::Base
<<<<<<< HEAD
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

=======
  has_many :events, through: :registrations

  def all_non_anon
    Guest.where(is_anon: false)
  end

  def all_anon
    Guest.where(is_anon: true)
  end
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
end
