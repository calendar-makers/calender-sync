class Meetup

  include HTTParty

  attr_reader :default_group_id, :default_group_urlname, :default_auth

  BASE_URL = 'https://api.meetup.com'
  API_KEY = ENV['MEETUP_API']
  UTC_OFFSET = 14400000

  # NATURE IN THE CITY DATA
  GROUP_ID = '1556336'#'8870202'
  GROUP_URLNAME = 'Meetup-API-Testing'#'Nature-in-the-City'

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
    Meetup.process_result(data, nil, 200)
  end

  def delete_event(id)
    data = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{Meetup.options_string(default_auth)}")
    Meetup.process_result(data, nil, 200)
  end

  # ASK ABOUT ANNOUNCING EVENTS... If necessary it can be done here automatically...or with edit_event
  def push_event(event)
    options = {}
    options[:body] = {group_id: default_group_id, group_urlname: default_group_urlname}.merge(default_auth)
    options[:body].merge!(get_event_data(event))
    #options[:body].merge!(announce:'true')
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    data = HTTParty.post("#{BASE_URL}/2/event", options)
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, 201)
  end

  def pull_event(id)
    data = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{Meetup.options_string(default_auth)}")
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, 200)
  end

  def pull_events(options={})
    if options[:event_id].nil? && options[:group_urlname].nil?
      options.merge!(group_id: default_group_id) # if user gave no options, then pull by default group id
    end
    options.merge!(default_auth)
    options.merge!(status: 'past,upcoming')
    data = HTTParty.get("#{BASE_URL}/2/events?#{Meetup.options_string(options)}")
    Meetup.process_result(data, lambda {|arg| Meetup.parse_event(arg)}, 200)
  end

  def pull_rsvps(options={})
    options.merge!(default_auth)
    options.merge!({rsvp: 'yes'})
    data = HTTParty.get("#{BASE_URL}/2/rsvps?#{Meetup.options_string(options)}")
    Meetup.process_result(data, lambda {|arg| Meetup.parse_rsvp(arg)}, 200)
  end

  def self.process_result(result, handler, success_code)
    success = result.code == success_code
    return success if handler.nil?
    if success
      parse_data(result, handler)
    end
  end

  def self.parse_data(result, handler)
    data = result.parsed_response
    elements = data['results']
    if elements
      elements.map {|element| handler.call(element)}
    else
      handler.call(data)
    end
  end

  def self.parse_event(data)
    event = {}
    event[:meetup_id] = data['id']
    event[:name] = data['name']
    event[:description] = data['description']
    event[:organization] = data['group']['name']
    event[:url] = data['event_url']
    event[:how_to_find_us] = data['how_to_find_us']
    event[:status] = data['status']
    event.merge!(parse_dates(data))
    event.merge!(parse_venue(data))
  end

  def self.parse_dates(data)
    time = data['time']
    offset = data['utc_offset']
    duration = data['duration']
    {start: build_date(time, offset),
    end: build_date(time + (duration ? duration : 0), offset),
    updated: build_date(data['updated'], offset)}
  end

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

  def get_event_data(event)
    data = {}
    data[:name] = event[:name]
    data[:description] = event[:description]
    data[:venue_id] = get_meetup_venue_id(event)
    start = event[:start]
    data[:time] = set_time(start)
    data[:duration] = Meetup.get_milliseconds((event[:end] - start))
    data[:how_to_find_us] = event[:how_to_find_us]
    data
  end

  def set_time(date)
    Meetup.get_milliseconds(date) + UTC_OFFSET
    #local_offset = DateTime.now.offset
    #date.to_datetime.new_offset(local_offset).to_i * 1000
    #date.to_datetime.change(offset: local_offset).to_i * 1000
  end

  def get_meetup_venue_id(event)
    data = create_venue(event)
    code = data.code
    if code == 201
      data.parsed_response['id']
    elsif code == 409 # Match was found. Meetup refused to create a new venue
      Meetup.get_matched_venue_id(data)
    else
      ''
    end
  end

  def self.get_matched_venue_id(data)
    data.parsed_response['errors'][0]['potential_matches'][0]['id']
  end

  def create_venue(event)
    options = {}
    options[:body] = Meetup.get_event_venue_data(event).merge(default_auth)
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/#{default_group_urlname}/venues", options)
  end

  def self.get_event_venue_data(event)
    meetup_keys = [:name, :address_1, :city, :state, :zip, :country]
    db_keys= [:venue_name, :address_1, :city, :state, :zip, :country]
    venue = {}
    db_keys.each_index {|index| venue[meetup_keys[index]] = event[db_keys[index]]} if event
    venue
  end

  def self.build_date(time, utc_offset)
    if time
      (time = time + utc_offset) if utc_offset
      millis_per_second = 1000
      Time.at(time / millis_per_second).to_datetime
    end
  end

  def self.parse_rsvp(data)
    rsvp = {}
    rsvp[:event_id] = data['event']['id']
    member = data['member']
    rsvp[:meetup_id] = member['member_id']
    rsvp[:meetup_name] = member['name']
    rsvp[:invited_guests] = data['guests']
    rsvp[:updated] = build_date(data['mtime'], data['utc_offset'])
    rsvp
  end

  def self.options_string(options)
    options.map { |key,value| "#{key}=#{value}" }.join("&")
  end

  def self.get_milliseconds(date)
    date.to_i * 1000
  end

end

