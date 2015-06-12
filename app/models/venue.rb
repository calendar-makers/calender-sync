module Venue

  def self.get_meetup_venue_id(event, event_id)
    if event_id.blank? && Venue.is_blank_venue?(event)  # new and empty -> nil
      return
    elsif event_id.present? && Venue.is_blank_venue?(event)   # edit and empty -> reset
      0
    else
      Venue.get_new_meetup_venue_id(event)
    end
  end

  #####################################################
  ##############  PRIVATE  ############################
  #####################################################

  def self.get_id(event_id)
    Meetup.new.get_venues(event_id: event_id)[0]['id']
  end

  def self.is_blank_venue?(event)
    [:venue_name, :city, :zip, :state, :country, :st_number, :st_name].each {|key| return false if event[key].present?}
    true
  end

  def self.get_new_meetup_venue_id(event)
    data = Meetup.new.create_venue(event)
    code = data.code
    if code == 201
      data.parsed_response['id']
    elsif code == 409 # Match was found. Meetup refused to create a new venue
      Venue.get_best_matched_venue_id(data, event[:venue_name])
    end
  end

  # Necessary if venue creation returns previously created venues
  def self.get_best_matched_venue_id(data, venue_name)
    matches = data.parsed_response['errors'][0]['potential_matches']
    matches.each do |venue|
      id = venue['id']
      return id if venue_name == venue['name']
    end
    matches[0]['id']  # If no match just return the first
  end

  def self.get_event_venue_data(event)
    return {} if event.nil?
    keys = [:city, :state, :zip, :country]
    venue = {}
    keys.each_index {|index| venue[keys[index]] = event[keys[index].to_s]}
    venue[:address_1] = "#{event['st_number']} #{event['st_name']}"
    venue[:name] = event['venue_name']
    venue.compact
  end
end