require 'httparty'

class Meetup

  include HTTParty
  debug_output $stderr

  attr_accessor :options

  BASE_URL = 'https://api.meetup.com'
  API_KEY = ENV['MEETUP_API']

  # NATURE IN THE CITY DATA
  GROUP_ID = '8870202'
  GROUP_URLNAME = 'Nature-in-the-City'

  def initialize(options={})
    # Needs either a key, or a token.
    # Don't think you can send both...
    admin_data = options[:access_token] ? {} : {key: options[:key]||API_KEY}
    @options = options.merge(admin_data)
  end

  # FOR FUTURE ITERATIONS
=begin
  def edit_event(id)
    # All params other than key are optional
    @options[:body] = {} # CREATE A FUNCTION THAT CHECKS AND BUILDS BODY
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event", @options)
    # Also returns the new event as pull_event(id) would
    data.code == 200
  end

  # Consider deleting when pulling...check for some field in Meetup for that case
  def delete_event(id)
    # No args other than the key are required
    data = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{options_string}")
    data.code == 200
  end
=end


  def dummy_push_event()
    # solely for testing, push a dummy event to the sandbox
    @options = {}
    url = "Meetup-API-Testing"
    id = '1556336'
    name = 'Calendar Sync- dummy'
    @options[:headers]= {'Content-Type' => 'application/x-www-form-urlencoded'}
    @options[:query] = {group_id: id, group_urlname: url, name: name, access_token: User.first.token}
    data = HTTParty.post("#{BASE_URL}/2/event", @options)
    byebug
  end

  def push_event(parameters = {})
    # Remember to check for allowed fields
    # Required parameters: group_id, group_urlname, name
    # Note: for the location, only the venue_id can be passed. Nothing else.
    # To get the venue_id we have to make another api call to either create or get the venue first
    @options[:body] = {group_id: GROUP_ID, group_urlname: GROUP_URLNAME}.merge(get_event_data(event))
    @options[:body].merge(parameters)
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event", @options)
    # Also returns the new event as pull_event(id) would
    data.code == 201 # HTTP code for creation
  end

  def create_venue(event)
    @options[:body] = get_event_venue_data(event)
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}  ##### DOUBTS ABOUT THIS. The api doesn't say
    data = HTTParty.post("#{BASE_URL}/#{GROUP_URLNAME}/venues", @options)
    # returns either an existing venue matching the params you gave, or
    # if there are multiple matches then it will return ERROR CODE 409 Conflict
    # which will contain a list of possible matches.
  end

  def pull_event(id)
    data = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{options_string}")
    build_event(data.parsed_response) if data.code == 200
  end

  def pull_events()
    if @options[:event_id].nil? && @options[:group_urlname].nil?
      @options.merge!(group_id: GROUP_ID) # if user gave no options, then pull by default group id
    end
    data = HTTParty.get("#{BASE_URL}/2/events?#{options_string}")
    if data.code == 200
      events = data.parsed_response['results']
      events.map {|event_data| build_event(event_data)}
    end
  end

  def pull_rsvps(id)
    @options.merge!({event_id: id, rsvp: 'yes'})
    data = HTTParty.get("#{BASE_URL}/2/rsvps?#{options_string}")
    if data.code == 200
      rsvps = data.parsed_response['results']
      rsvps.map {|rsvp_data| build_rsvp(rsvp_data)}
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

  def build_event(data)
     {meetup_id: data['id'],
       name: data['name'],
       description: data['description'],
       organization: data['group']['name'],
       ##############################  READ COMMENTS ON TOP OF BUILD LOCATION TO UNDERSTAND THE REDUNDANCY
       location: build_location(data),
       ##############################
       start: build_date(data['time']),
       duration: build_duration(data),
       updated: build_date(data['updated']),
       url: data['event_url'],
       how_to_find_us: data['how_to_find_us'],
       status: data['status']}.merge(build_venue(data))
  end

  # Helper method used to build_event
  def build_venue(data)
    if data && data = data['venue']
      {address_1: data['address_1'],
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
    byebug
    data = create_venue(event)
    if data.code == 200
      data['id']
    elsif data.code == 409 # you should have gotten a list of venues
      find_venue_match(event, data['results'])['id']
    end
  end

  def find_venue_match(event, venues)

  end

  # Used to package venue data to be sent in create_venue
  def get_event_venue_data(event)
    keys = [:address_1, :city, :state, :zip, :country]
    venue = {}
    keys.each {|k| venue[k] = event[k]} if event
    venue
  end

  def build_date(data)
    millis_per_second = 1000
    Time.at(data / millis_per_second).to_datetime
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
  # SHOULD REMOVE but NOT NOW...IT's MAJOR REFACTORING. Would you consider keeping it for easy printing???

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

  def build_rsvp(data)
    {event_id: data['event']['id'],
     meetup_id: data['member']['member_id'],
     meetup_name: data['member']['name'],
     invited_guests: data['guests'],
     updated: build_date(data['mtime'])}
  end

  def options_string
    @options.map { |k,v| "#{k}=#{v}" }.join("&")
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
