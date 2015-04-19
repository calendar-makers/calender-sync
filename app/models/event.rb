class Event < ActiveRecord::Base
  has_many :registrations
  has_many :guests, through: :registrations
  has_many :registrations

  has_attached_file :image, styles: {small: "150x100", medium: "300x200", large: "450,300" }, :url => "/assets/:id/:style/:basename.:extension", :path => "public/assets/:id/:style/:basename.:extension", :default_url => "/assets/missing.png"

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
    :start => start.iso8601,
    :url => Rails.application.routes.url_helpers.event_path(id)
  }
  end

  # def self.scoped(options=nil)
  #   options ? where(nil).apply_finder_options(options, true) : where(nil)
  # end

  def self.check_if_fields_valid(arg1)
    result = {}
    result[:message] = []
    result[:value] = true
    arg1.each do |k, v|
      if v == nil || v == ''
        result[:value] = false
        result[:message].append k.to_s
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
    # Here we can pass the token to the API call if needed. Like so: {access_token: token}
    meetup_events = Meetup.new.pull_events(options)
    if meetup_events.respond_to?(:each)
      meetup_events.each_with_object([]) {|event, candidate_events| candidate_events << Event.new(event)}
    end
  end

  def self.make_events_local(events)
    if !events.blank?
      events_bin = []
      events.each do |event|
        stored_event = Event.find_by_meetup_id(event[:meetup_id])
        if stored_event.nil?
          event.save!
        elsif stored_event.needs_updating?(event[:updated])
          stored_event.apply_update(event)
        else # already stored and unchanged since
          next
        end

        events_bin << event
      end

      Event.make_remote_deletions_local(events)
      events_bin
    end
  end

  def self.make_remote_deletions_local(remote_events)
    local_event_ids = Event.pluck(:meetup_id)
    remote_event_ids = []
    remote_events.each_with_object(remote_event_ids) {|event, array| array << event.meetup_id}
    remotely_deleted_ids = local_event_ids - remote_event_ids
    remotely_deleted_ids.each {|id| Event.find_by_meetup_id(id).destroy}
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
    if !rsvps.blank?
      new_guest_names = []
      rsvps.each do |rsvp|

        guest = Guest::find_guest_by_meetup_rsvp(rsvp) || Guest::create_guest_by_meetup_rsvp(rsvp)

        registration = Registration.find_by({event_id: id, guest_id: guest.id})
        if registration.nil?
          Registration.create!(event_id: id, guest_id: guest.id,
                               invited_guests: rsvp[:invited_guests],
                               updated: rsvp[:updated])
        elsif registration.needs_updating?(rsvp[:updated])
          registration.update_attributes!(invited_guests: rsvp[:invited_guests],
                                          updated: rsvp[:updated])
        else # neither new nor updated
          next
        end

        new_guest_names << guest.first_name + (' ' if guest.last_name) + guest.last_name
      end

      new_guest_names
    end
  end

  def format_start_date
    Event.format_date(start)  end

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
    keys.each {|k| self[k] = event[k]}
  end

end
