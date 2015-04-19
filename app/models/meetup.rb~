class Meetup

  include HTTParty

  attr_reader :default_group_id, :default_group_urlname, :default_auth

  BASE_URL = 'https://api.meetup.com'
  API_KEY = ENV['MEETUP_API']
  UTC_OFFSET = 14400000

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

  def edit_event(args)
    options = {}
    options[:body] = args[:updated_fields].merge(default_auth)
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event/#{args[:id]}", options)
    # Also returns the new event as pull_event(id) would
    data.code == 200
  end

  # Consider deleting when pulling...check for some field in Meetup for that case
  def delete_event(id)
    data = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{self.class.options_string(default_auth)}")
    data.code == 200
  end

  # ASK ABOUT ANNOUNCING EVENTS... If necessary it can be done here automatically...or with edit_event
  def push_event(event)
    options = {}
    options[:body] = {group_id: default_group_id, group_urlname: default_group_urlname}.merge(default_auth)
    options[:body].merge!(get_event_data(event))
    #options[:body].merge!(announce:'true')
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event", options)
    self.class.parse_event(data.parsed_response) if data.code == 201
  end

  def pull_event(id)
    data = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{self.class.options_string(default_auth)}")
    self.class.parse_event(data.parsed_response) if data.code == 200
  end

  def pull_events(options={})
    if options[:event_id].nil? && options[:group_urlname].nil?
      options.merge!(group_id: default_group_id) # if user gave no options, then pull by default group id
    end
    options.merge!(default_auth)
    data = HTTParty.get("#{BASE_URL}/2/events?#{self.class.options_string(options)}")
    if data.code == 200
      events = data.parsed_response['results']
      events.map {|event_data| self.class.parse_event(event_data)}
    end
  end

  def pull_rsvps(id)
    options = {}
    options.merge!(default_auth)
    options.merge!({event_id: id, rsvp: 'yes'})
    data = HTTParty.get("#{BASE_URL}/2/rsvps?#{self.class.options_string(options)}")
    if data.code == 200
      rsvps = data.parsed_response['results']
      rsvps.map {|rsvp_data| self.class.parse_rsvp(rsvp_data)}
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

  def self.parse_event(data)
     {meetup_id: data['id'],
       name: data['name'],
       description: data['description'],
       organization: data['group']['name'],
       start: build_date(data['time'], data['utc_offset']),
       end: build_date(data['time'] + (data['duration']? data['duration'] : 0), data['utc_offset']),
       updated: build_date(data['updated'], data['utc_offset']),
       url: data['event_url'],
       how_to_find_us: data['how_to_find_us'],
       status: data['status']}.merge(parse_venue(data))
  end

  # Helper method used to parse_event
  def self.parse_venue(data)
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
  def get_event_data(event)
      {name: event[:name],
        description: event[:description],
        venue_id: get_meetup_venue_id(event),
        time: event[:start].to_i * 1000 + UTC_OFFSET,
        duration: (event[:end] - event[:start]).to_i * 1000,
        how_to_find_us: event[:how_to_find_us]}
  end

  def get_meetup_venue_id(event)
    data = create_venue(event)
    if data.code == 201
      data.parsed_response['id']
    elsif data.code == 409 # Match was found. Meetup refused to create a new venue
      self.class.get_matched_venue_id(data)
    else
      ''
    end
  end

  def self.get_matched_venue_id(data)
    data.parsed_response['errors'][0]['potential_matches'][0]['id']
  end

  def create_venue(event)
    options = {}
    options[:body] = self.class.get_event_venue_data(event).merge(default_auth)
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/#{default_group_urlname}/venues", options)
  end

  # Used to package venue data to be sent in create_venue
  def self.get_event_venue_data(event)
    meetup_keys = [:name, :address_1, :city, :state, :zip, :country]
    db_keys= [:venue_name, :address_1, :city, :state, :zip, :country]
    venue = {}
    db_keys.each_index {|i| venue[meetup_keys[i]] = event[db_keys[i]]} if event
    venue
  end

  def self.build_date(time, utc_offset)
    if time
      (time = time - utc_offset) if utc_offset
      millis_per_second = 1000
      Time.at(time / millis_per_second).to_datetime
    end
  end

  def self.build_duration(data)
    if data['duration']
      millis_per_hour = 3600000
      data['duration'].fdiv(millis_per_hour)
    end
  end

  def self.parse_rsvp(data)
    {event_id: data['event']['id'],
     meetup_id: data['member']['member_id'],
     meetup_name: data['member']['name'],
     invited_guests: data['guests'],
     updated: build_date(data['mtime'], data['utc_offset'])}
  end

  def self.options_string(options)
    options.map { |k,v| "#{k}=#{v}" }.join("&")
  end

end
