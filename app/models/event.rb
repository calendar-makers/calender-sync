class Event < ActiveRecord::Base
  has_many :registrations
  has_many :guests, through: :registrations
  has_many :registrations

  has_attached_file :image, styles: {original: "300x200"}, :url => "/assets/:id/:style/:basename.:extension", :path => "public/assets/:id/:style/:basename.:extension", :default_url => "/assets/missing.png"

  #validates_attachment_presence :image
  #validates_attachment_size :image, :less_than => 5.megabytes
  #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/jpg']

  do_not_validate_attachment_file_type :image

  # scope :between, lambda {|start_time, end_time|
  #   {:conditions => ["? < start < ?", Event.format_date(start_time), Event.format_date(end_time)] }
  # }

  def as_json(options = {})
    {
      :id => self.id,
      :title => self.name,
      :start => self.start.iso8601,
      :end => (self.end ? self.end.iso8601 : nil),
      :location => self.location,
      :description => self.description
    }
  end

  # def self.scoped(options=nil)
  #   options ? where(nil).apply_finder_options(options, true) : where(nil)
  # end

  def self.check_if_fields_valid(arg)
    result = {}
    result[:message] = []
    result[:value] = true
    arg.each do |key, value|
      if value.blank?
        result[:value] = false
        result[:message].append key.to_s
      end
    end
    result
  end

  def is_new?
    self.class.find_by_meetup_id(meetup_id).nil?
  end

  def needs_updating?(latest_update)
    updated < latest_update
  end

  def count_event_participants
    registrations.inject(0) do |sum, regis|
      guest_count = regis.invited_guests
      sum + 1 + (guest_count ? guest_count : 0 )
    end
  end

  def generate_participants_message
    'The total number of participants, including invited guests, so far is:' \
      " #{self.count_event_participants}"
  end

  def self.get_remote_events(options={})
    meetup_events = Meetup.new.pull_events(options)
    if meetup_events.respond_to?(:each)
      meetup_events.each_with_object([]) {|event, candidate_events| candidate_events << Event.new(event)}
    end
  end

  def self.process_remote_events(events)
    return if events.blank?
    events_bin = []
    events.each do |event|
      events_bin << event if Event.process_event(event)
    end
    events_bin
  end

  def self.process_event(event)
    stored_event = Event.find_by_meetup_id(event[:meetup_id])
    if stored_event.nil?
      event.save!
    elsif stored_event.needs_updating?(event[:updated])
      stored_event.apply_update(event)
    else # already stored and unchanged since
      false
    end
  end

  def self.remove_remotely_deleted_events(remote_events)
    return if remote_events.nil?
    remotely_deleted_ids = Event.get_remotely_deleted_ids(remote_events)
    remotely_deleted_ids.each {|id| Event.find_by_meetup_id(id).destroy}
  end

  def self.get_remotely_deleted_ids(remote_events)
    target_events = Event.where("start >= '#{DateTime.now - 1}'")
    local_event_ids = target_events.inject([]) {|array, event| array << event.meetup_id}
    remote_event_ids = remote_events.inject([]) {|array, event| array << event.meetup_id}
    local_event_ids - remote_event_ids
  end

  def self.get_upcoming_events
    Event.get_remote_events({status: 'upcoming'})
  end

  def self.get_past_events(from=nil, to=nil)
    Event.get_remote_events({status: 'past'}.merge Event.date_range(from, to))
  end

  def self.get_upcoming_third_party_events
    ids = Event.get_stored_third_party_ids
    if ids.size > 0
      options = {event_id: ids.join(',')}
      events = Event.get_remote_events({status: 'upcoming'}.merge options)
      return events if events
    end
    []
  end

  def self.get_past_third_party_events(from=nil, to=nil)
    ids = Event.get_stored_third_party_ids
    if ids.size > 0
      options = {event_id: ids.join(',')}
      range = Event.date_range(from, to)
      events = Event.get_remote_events(({status: 'past'}.merge options).merge range)
      return events if events
    end
    []
  end

  def self.date_range(from=nil, to=nil)
    (from || to) ? {time: "#{from},#{to}"} : {}
  end

  def self.store_third_party_events(ids)
    options = ids.respond_to?(:join) ? {event_id: ids.join(',')} : {}
    Event.process_remote_events(Event.get_remote_events(options))
  end

  def self.initialize_calendar_db
    upcoming_events = Event.get_upcoming_events
    past_events = Event.get_past_events
    remote_events = upcoming_events && past_events ? upcoming_events + past_events : nil
    process_remote_events(remote_events)
  end

  def self.synchronize_past_events
    group_events = Event.get_past_events('-1d', '')
    third_party_events = Event.get_past_third_party_events('-1d', '')
    remote_events = group_events && third_party_events ? group_events + third_party_events : nil
    process_remote_events(remote_events)
  end

  def self.synchronize_upcoming_events
    group_events = Event.get_upcoming_events
    third_party_events = Event.get_upcoming_third_party_events
    remote_events = group_events && third_party_events ? group_events + third_party_events : nil
    Event.remove_remotely_deleted_events(remote_events)
    process_remote_events(remote_events)
  end

  def self.get_default_group_name
    Meetup::GROUP_NAME
  end

  def self.get_stored_third_party_ids
    Event.all.each_with_object([]) {|event, ids| ids << event.meetup_id if event.is_third_party?}
  end

  def is_third_party?
    default_group_name = Event.get_default_group_name
    group_name = organization
    group_name && group_name != default_group_name
  end

  def apply_update(new_event)
    new_pairs = new_event.attributes
    modified_pairs = new_pairs.select {|key, value| value && value != self[key]}
    update_attributes(modified_pairs)
  end

  def get_remote_rsvps
    Meetup.new.pull_rsvps(event_id: meetup_id)
  end

  def merge_meetup_rsvps
    rsvps = get_remote_rsvps
    return if rsvps.blank?
    new_guest_names = []
    rsvps.each do |rsvp|
      guest = Guest.find_by_meetup_rsvp(rsvp) || Guest.create_guest_by_meetup_rsvp(rsvp)
      if process_rsvp(rsvp, guest.id)
        new_guest_names << guest.first_name + (' ' if guest.last_name) + guest.last_name
      end
    end
    new_guest_names
  end

  def process_rsvp(rsvp, guest_id)
    registration = Registration.find_by({event_id: id, guest_id: guest_id})
    if registration.nil?
      Registration.create!(event_id: id, guest_id: guest_id,
                           invited_guests: rsvp[:invited_guests],
                           updated: rsvp[:updated])
    elsif registration.needs_updating?(rsvp[:updated])
      registration.update_attributes!(invited_guests: rsvp[:invited_guests],
                                      updated: rsvp[:updated])
    else # neither new nor updated
      false
    end
  end

  def self.get_requested_ids(data)
    data.keys.select {|key| key =~ /^event.+$/} if data.respond_to? :keys
  end

  def self.cleanup_ids(ids)
    clean_ids = []
    ids.each {|id| clean_ids << id.gsub("event", "")} if ids.respond_to? :each
    clean_ids
  end

  def self.get_event_ids(args)
    Event.cleanup_ids(Event.get_requested_ids(args))
  end

  def format_start_date
    Event.format_date(start)
  end

  def format_end_date
    Event.format_date(self.end)
  end

  def self.format_date(date)
    date.strftime('%m/%d/%Y at %I:%M%p') if date
  end

  def location
    location = []
    location << address_1
    location << city.to_s + (state ? (', ' + state + ' ') : ' ') + zip.to_s
    location << country
    location.join("\n")
  end

  def update_meetup_fields(event)
    keys = [:meetup_id, :updated, :url, :status]
    keys.each {|key| self[key] = event[key]}
  end

  def self.display_message(events)
    if events.nil?
      "Could not add event. Please retry."
    elsif events.empty?
      "These events are already in the Calendar, and are up to date."
    elsif events.size > 0
      names = []
      events.each {|event| names << event[:name]}
      "Successfully added: #{names.join(', ')}."
    end
  end

end
