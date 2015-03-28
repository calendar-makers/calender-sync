require 'httparty'


class Meetup

  include HTTParty
  debug_output $stderr

  BASE_URL = 'https://api.meetup.com'
  API_KEY = ENV['MEETUP_API']

  # NATURE IN THE CITY DATA
  GROUP_ID = '8870202'
  GROUP_URLNAME = 'Nature-in-the-City'

  def initialize(options={})
    @options = options.merge({key: API_KEY})
  end

  def pull_event(id)
    response = HTTParty.get("#{BASE_URL}/2/event/#{id}?#{options_string(@options)}")
    response.parsed_response
  end

  def push_event()
    # Remember to check for allowed fields
    # Required parameters: group_id, group_urlname, name
    @options[:body] = {group_id: GROUP_ID, group_urlname: GROUP_URLNAME, name: 'Event Test'} # CREATE A FUNCTION THAT CHECKS AND BUILDS BODY
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/2/event", @options)
  end

  def edit_event(id)
    # All params other than key are optional
    @options[:body] = {} # CREATE A FUNCTION THAT CHECKS AND BUILDS BODY
    @options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    HTTParty.post("#{BASE_URL}/2/event", @options)
    # Response is same as pull_event(id)
  end

  def delete_event()
    # No args other than the key are required
    response = HTTParty.delete("#{BASE_URL}/2/event/#{id}?#{options_string(@options)}")
    # response is HTTP200 for success otherwise 401
  end

  def pull_events(group_id=GROUP_ID)
    @options = @options.merge(group_id: group_id)
    response = HTTParty.get("#{BASE_URL}/2/events?#{options_string(@options)}")
    response.parsed_response['results']
  end

  def pull_rsvp(id)
    @options = @options.merge({event_id: id})
    response = HTTParty.get("#{BASE_URL}/2/rsvps?#{options_string(@options)}")
    response.parsed_response['results']
  end


  private

  def options_string(options)
    @options.map { |k,v| "#{k}=#{v}" }.join("&")
  end

  def find_group_name(event_id)
    #maybe
  end

  def find_group_id(group_name)
    #need to investigate... apparently the field group_urlname is not standardized for all groups...
  end

end