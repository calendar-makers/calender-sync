class Meetup

  include HTTParty

  attr_reader :default_group_id, :default_group_urlname, :default_auth

  BASE_URL = 'https://api.meetup.com'
  API_KEY = ENV['MEETUP_API']

  # NATURE IN THE CITY DATA
  GROUP_ID = '8870202'
  GROUP_URLNAME = 'Nature-in-the-City'

  def default_group_urlname=(urlname='')
    @default_group_urlname = urlname.blank? ? GROUP_URLNAME : urlname
  end

  def default_group_id=(id='')
    @default_group_id = id.blank? ? GROUP_ID : id
  end

  def default_auth=(params)
    token, key = params
    @default_auth = token ? {access_token: token} : {key: key||API_KEY}
  end

  def initialize(options={})
    # Needs either a key, or a token.
    self.default_auth = options[:access_token], options[:key]
    self.default_group_urlname = options[:group_urlname]
    self.default_group_id = options[:group_id]
  end

=begin
  def edit_event(id)
    # All params other than key are optional
    @options[:body] = {} # CREATE A FUNCTION THAT CHECKS AND BUILDS BODY
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event", @options)
    # Also returns the new event as pull_event(id) would
    data.code == 200
  end
=end

  # Consider deleting when pulling...check for some field in Meetup for that case
  def delete_event(id)
    # No args other than the key are required
    data = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{options_string(default_auth)}")
    data.code == 200
  end



  def dummy_push_event()
    # solely for testing, push a dummy event to the sandbox
    @options = {}
    url = "Meetup-API-Testing"
    id = '1556336'
    name = 'Calendar Sync- dummy'
    @options[:headers]= {'Content-Type' => 'application/x-www-form-urlencoded'}
    @options[:body] = {group_id: id, group_urlname: url, name: name, key:'3837476f222cc2b6b365513821d38'}
    byebug
    data = HTTParty.post("#{BASE_URL}/2/event", @options)
    byebug
  end

  def push_event(event)
    # Remember to check for allowed fields
    # Required parameters: group_id, group_urlname, name
    # Note: for the location, only the venue_id can be passed. Nothing else.
    # To get the venue_id we have to make another api call to either create or get the venue first
    byebug
    options = {}
    options[:body] = {group_id: default_group_id, group_urlname: default_group_urlname}.merge(default_auth)
    options[:body].merge!(get_event_data(event))
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    byebug
    data = HTTParty.post("#{BASE_URL}/2/event", options)
    # Also returns the new event as pull_event(id) would
    data.code == 201 # HTTP code for creation
  end

  def pull_event(id)
    data = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{options_string(default_auth)}")
    parse_event(data.parsed_response) if data.code == 200
  end

  def pull_events
    if @options[:event_id].nil? && @options[:group_urlname].nil?
      @options.merge!(group_id: default_group_id) # if user gave no options, then pull by default group id
    end
    @options.merge!(default_auth)
    data = HTTParty.get("#{BASE_URL}/2/events?#{options_string}")
    if data.code == 200
      events = data.parsed_response['results']
      events.map {|event_data| parse_event(event_data)}
    end
  end

  def pull_rsvps(id)
    @options.merge!(default_auth)
    @options.merge!({event_id: id, rsvp: 'yes'})
    data = HTTParty.get("#{BASE_URL}/2/rsvps?#{options_string}")
    if data.code == 200
      rsvps = data.parsed_response['results']
      rsvps.map {|rsvp_data| parse_rsvp(rsvp_data)}
    end
  end



  #private

  # This fields depend on the input given at Meetup's end.
  # If Meetup error checking fails, then some minor fields
  # may be nil. At this point I'm choosing to still allow
  # the event to be built despite the wrong fields.
  # Especially since they may be fixed and re-pulled later
  # The only essential fields are: meetup_id, organization
  # but those ones are implicitly always correct

  def parse_event(data)
     {meetup_id: data['id'],
       name: data['name'],
       description: data['description'],
       organization: data['group']['name'],
       ##############################  READ COMMENTS ON TOP OF BUILD LOCATION TO UNDERSTAND THE REDUNDANCY
       location: build_location(data),
       ##############################
       start: build_date(data['time'], data['utc_offset']),
       duration: build_duration(data),
       updated: build_date(data['updated'], data['utc_offset']),
       url: data['event_url'],
       how_to_find_us: data['how_to_find_us'],
       status: data['status']}.merge(parse_venue(data))
  end

  # Helper method used to parse_event
  def parse_venue(data)
    if data && data = data['venue']
      {venue_name: data['name'],
        address_1: data['address_1'],
        city: data['city'],
        zip: data['zip'],
        state: data['state'],
        country: data['country']}
    else
      {}
    end
  end

  # Used to package event data to be sent in push_event
  # Likely to be used in edit_event as well
  def get_event_data(event)
      {name: event[:name],
        description: event[:description],
        venue_id: get_meetup_venue_id(event),
        time: event[:start].to_i,
        duration: event[:duration],
        how_to_find_us: event[:how_to_find_us]}
  end

  def get_meetup_venue_id(event)
    data = create_venue(event)
    if data.code == 201
      data.parsed_response['id']
    elsif data.code == 409 # Match was found. Meetup refused to create a new venue
      data.parsed_response['errors'][0]['potential_matches']['id']
    else
      ''
    end
  end

  def create_venue(event)
    @options[:body] = self.class.get_event_venue_data(event).merge(default_auth)
    #@options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/#{default_group_urlname}/venues", @options)
    # returns either an existing venue matching the params you gave, or
    # if there are multiple matches then it will return ERROR CODE 409 Conflict
    # which will contain a list of possible matches.
  end

  # Used to package venue data to be sent in create_venue
  def self.get_event_venue_data(event)
    meetup_keys = [:name, :address_1, :city, :state, :zip, :country]
    db_keys= [:venue_name, :address_1, :city, :state, :zip, :country]
    venue = {}
    db_keys.each_index {|i| venue[meetup_keys[i]] = event[db_keys[i]]} if event
    venue
  end

  def build_date(time, utc_offset)
    if time
      (time = time + utc_offset) if utc_offset
      millis_per_second = 1000
      Time.at(time / millis_per_second).to_datetime
    end
  end

  def build_duration(data)
    if data['duration']
      millis_per_hour = 3600000
      data['duration'].fdiv(millis_per_hour)
    end
  end


  # NOTE: I ADDED ALL THESE 5 FIELDS IN THE DB because it was necessary
  # to create new venues(i.e. request new venues).
  # THIS MAKES THE "LOCATION" column USELESS.
  # SHOULD REMOVE but NOT NOW...IT's MAJOR REFACTORING. Will do next iteration

  # For some events the 'venue' field does not exist
  def build_location(data)
    if data && data = data['venue']
      location = []
      location << data['address_1']
      location << data['city']
      location << data['zip']
      location << data['state']
      location << data['country']
      location.join(', ')
    end
  end

  def parse_rsvp(data)
    {event_id: data['event']['id'],
     meetup_id: data['member']['member_id'],
     meetup_name: data['member']['name'],
     invited_guests: data['guests'],
     updated: build_date(data['mtime'], data['utc_offset'])}
  end

  def options_string(options)
    options.map { |k,v| "#{k}=#{v}" }.join("&")
  end

  # FOR FUTURE ITERATIONS
=begin
  def find_group_name(event_id)
    #maybe
  end

  def find_group_id(group_name)
    #need to investigate... apparently the field group_urlname is not standardized for all groups...
  end
=end

end
