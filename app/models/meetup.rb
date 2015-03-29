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
    @options = options.merge({key: options[:key]||API_KEY})
  end

  def edit_event(id)
    # All params other than key are optional
    @options[:body] = {} # CREATE A FUNCTION THAT CHECKS AND BUILDS BODY
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/2/event", @options)
    # Response is same as pull_event(id)
  end

  # Consider deleting when pulling...check for some field in Meetup for that case
  def delete_event()
    # No args other than the key are required
    data = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{options_string}")
    # response is HTTP200 for success otherwise 401
  end

  def push_event()
    # Remember to check for allowed fields
    # Required parameters: group_id, group_urlname, name
    @options[:body] = {group_id: GROUP_ID, group_urlname: GROUP_URLNAME, name: 'Event Test'} # CREATE A FUNCTION THAT CHECKS AND BUILDS BODY
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/2/event", @options)
  end

  def pull_event(id)
    data = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{options_string}")
    build_event(data.parsed_response) if data.code == 200
  end

  def pull_events(group_id=GROUP_ID)
    @options = @options.merge(group_id: group_id)
    data = HTTParty.get("#{BASE_URL}/2/events?#{options_string}")
    if data.code == 200
      events = data.parsed_response['results']
      events.map {|event_data| build_event(event_data)}
    end
  end

  def pull_rsvps(id)
    @options = @options.merge({event_id: id})
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
       location: build_location(data),
       start: build_date(data['time']),
       duration: build_duration(data),
       updated: build_date(data['updated']),
       url: data['event_url'],
       how_to_find_us: data['how_to_find_us'],
       status: data['status']}
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

  def find_group_name(event_id)
    #maybe
  end

  def find_group_id(group_name)
    #need to investigate... apparently the field group_urlname is not standardized for all groups...
  end

end