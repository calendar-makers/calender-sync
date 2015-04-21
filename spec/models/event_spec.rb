require 'spec_helper'
require 'rails_helper'

RSpec.describe Event, type: :model do

  describe "Invalid field checking" do
    it "should return hash with :value => true if all keys are mapped to something" do
      event_hash = { name: 'coyote appreciation',
                     location: 'yosemite',
                     organization: 'nature loving',
                     start: '8-mar-2016',
                     description: 'watch coyotes' }
      result = Event.check_if_fields_valid(event_hash)
      expect(result[:message]).to be_empty
      expect(result[:value]).to be_truthy
    end

    it "should return hash with :value => false if nil or empty string" do
      event_hash = { name: '' }
      result = Event.check_if_fields_valid(event_hash)
      expect(result[:message]).to eq(['name'])
      expect(result[:value]).to be_falsey
    end
  end

  describe "#generate_participants_message" do
    it "returns the string reporting the total participants" do
      total_participants = 100000
      allow_any_instance_of(Event).to receive(:count_event_participants).and_return(total_participants)
      string = Event.new.generate_participants_message
      expect(string).to eq("The total number of participants, including invited guests, so far is: #{total_participants}")
    end
  end

  describe "#count_events_participants" do
    let(:event) {Event.new}

    context "with at least a positive rsvp" do
      it "gives the total number of attendees" do
        event.registrations << Registration.new(invited_guests: 1000)
        event.registrations << Registration.new(invited_guests: 0)
        event.save!
        total = event.count_event_participants
        expect(total).to eq(1002)
      end
    end

    context "with no positive rsvps" do
      it "gives zero attendees" do
        total = event.count_event_participants
        expect(total).to eq(0)
      end
    end
  end

  describe "#is_new?" do
    context "with a new event" do
      it "returns positive" do
        event = Event.new
        result = event.is_new?
        expect(result).to be_truthy
      end
    end

    context "with an already pulled event" do
      it "returns negative" do
        id = '1000'
        event = Event.create!(meetup_id: id)
        result = event.is_new?
        expect(result).to be_falsey
      end
    end
  end

  describe "#is_updated" do
    context "with updated event" do
      it "returns true" do
        event = Event.new(updated: Time.now)
        result = event.needs_updating?(Time.now + 3600)
        expect(result).to be_truthy
      end
    end

    context "with no event update" do
      it "returns false" do
        event = Event.new(updated: Time.now)
        result = event.needs_updating?(Time.now)
        expect(result).to be_truthy
      end
    end
  end

  describe "#format_start_date" do
    let(:date) {Time.utc(2002, 10, 31, 0, 2)}
    let(:formatted_date) {'10/31/2002 at 12:02AM'}

    it "returns the date in a simpler form" do
      event = Event.new(start: date)
      result = event.format_start_date
      expect(result).to eq(formatted_date)
    end
  end

  describe "#format_end_date" do
    let(:date) {Time.utc(2002, 10, 31, 0, 2)}
    let(:formatted_date) {'10/31/2002 at 12:02AM'}

    it "returns the date in a simpler form" do
      event = Event.new(end: date)
      result = event.format_end_date
      expect(result).to eq(formatted_date)
    end
  end

  describe "::make_events_local" do
    let(:event) {[Event.new]}

    context "with new events" do
      it "saves the event in the db" do
        expect_any_instance_of(Event).to receive(:save!)
        Event.make_events_local(event)
      end
    end

    context "with an updated event" do
      it "updates an already stored event with the fields of the input event" do
        event[0][:meetup_id] = '123'
        event[0][:updated] = Time.now + 200000
        old_event = Event.new(updated: Time.now, meetup_id: '123')

        allow(Event).to receive(:find_by_meetup_id).with('123').and_return(old_event)
        expect(old_event).to receive(:apply_update)
        Event.make_events_local(event)
      end
    end

    context "with an old event" do
      it "does nothing for an old unchanged event" do
        event[0][:meetup_id] = '123'
        event[0][:updated] = Time.now
        stored_event = Event.new(updated: Time.now, meetup_id: '123')

        allow(Event).to receive(:find_by_meetup_id).with('123').and_return(stored_event)
        expect(stored_event).not_to receive(:apply_update)
        Event.make_events_local(event)
      end
    end
  end

  describe "#merge_meetup_rsvps" do
    let(:event) {Event.new(id: 1)}
    let(:rsvp) {[{:event_id=>"qdwhxgytgbxb", :meetup_id=>82190912,
                  :meetup_name=>"Amber Hasselbring", :invited_guests=>0,
                  :updated=> Time.now}]}
    let(:guest) {Guest.new(id: 1, first_name: 'chester', last_name: 'copperpot')}

      before(:each) do
        allow_any_instance_of(Event).to receive(:get_remote_rsvps).and_return(rsvp)
        allow(Guest).to receive(:find_guest_by_meetup_rsvp).and_return(guest)
      end

    context "with new events" do
      it "saves the rsvp in the db" do
        allow(Registration).to receive(:find_by).and_return(nil)
        expect(Registration).to receive(:create!)
        event.merge_meetup_rsvps
      end
    end

    context "with an updated event" do
      it "updates an already stored event" do
        old_rsvp = Registration.new(updated: Time.now - 30000)
        allow(Registration).to receive(:find_by).and_return(old_rsvp)
        expect(old_rsvp).to receive(:update_attributes!)
        event.merge_meetup_rsvps
      end
    end

    context "with an old unchanged event" do
      it "does nothing for an old unchanged event" do
        stored_rsvp = Registration.new(updated: Time.now)
        allow(Registration).to receive(:find_by).and_return(stored_rsvp)
        expect(stored_rsvp).not_to receive(:update_attributes!)
        event.merge_meetup_rsvps
      end
    end
  end


  describe "#apply_update" do
    let(:event) {Event.new(name: 'walking')}

    context "with updated event" do
      let(:other_event) {Event.new(name: 'sitting')}

      it "computes the updated key value pairs and updates self" do
        expect(event).to receive(:update_attributes).with('name' => 'sitting')
        event.apply_update(other_event)
      end
    end

    context "with unchanged event" do
      let(:other_event) {Event.new(name: 'walking')}

      it "finds no updated key value pairs and it does not update self" do
        expect(event).to receive(:update_attributes).with({})
        event.apply_update(other_event)
      end
    end

  end
=begin
  describe '#location' do
    let(:location_data) {{'address_1' => '145 peep st', 'city' => 'New York',
                          'zip' => '90210', 'state' => 'NY', 'country' => 'US'}}
    let(:event) {Event.new(location_data)}
    let(:location) {[]}
    it 'returns a complete location string' do
      location_data.each {|k, v| location << v}
      expect(event.location).to eq("145 peep st\nNew York, NY 90210\nUS")
    end
  end
=end

  describe '#location' do
    let(:location) {[]}

    it 'returns a complete location string' do
      location_data = {'address_1' => '145 peep st', 'city' => 'New York',
                            'zip' => '90210', 'state' => 'NY', 'country' => 'US'}
      event = Event.new(location_data)
      location_data.each {|k, v| location << v}
      expect(event.location).to eq("145 peep st\nNew York, NY 90210\nUS")
    end

    it 'handles nil state fields' do
      location_data = {'address_1' => '145 peep st', 'city' => 'New York',
                       'zip' => '90210', 'state' => nil, 'country' => 'US'}
      event = Event.new(location_data)
      expect(event.location).to eq("145 peep st\nNew York 90210\nUS")
    end

  end

  describe '#remove_remotely_deleted_events' do
    before(:each) do
      @event_1 = Event.create!(meetup_id: '12345')
      @event_2 = Event.create!(meetup_id: '678910')
      @local_events = [@event_1, @event_2]
    end

    context 'with no remote deletions' do
      let(:remote_events) {@local_events}

      it 'does nothing' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.all.size).to eq(@local_events.size)
      end
    end

    context 'with one remote deletion (@event_2)' do
      let(:remote_events) {[@event_1]}

      it 'deletes the local copy of @event_2' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.find_by_meetup_id('678910')).to be_nil
      end
    end
  end

  describe "::get_requested_ids" do
    let(:data) {{event123: "1", e123vent: "2", evenABC: "3", event: "4", event12abc: "5"}}
    it "Selects only ids which match /^event.*/" do
      result = Event.get_requested_ids(data)
      expect(result).to eq([:event123, :event12abc])
    end
  end

  describe "::cleanup_ids" do
    let(:dirty_ids) {['event123', 'event1456', 'eventABC']}
    let(:clean_ids) {['123', '1456', 'ABC']}

    it 'should return only pure ids' do
      result = Event.cleanup_ids(dirty_ids)
      expect(result).to eq(clean_ids)
    end
  end

  describe "::display_message" do

    context "with at least one event" do
      let(:events) {[Event.new(name: 'gardening'), Event.new(name: 'swimming')]}

      it "returns a message with the added event names" do
        result = Event.display_message(events)
        expect(result).to eq("Successfully added: gardening, swimming.")
      end
    end

    context "with zero events" do
      let(:events) {[]}

      it "returns a message stating that the RSVP for the event is up to date with Meetup" do
        result = Event.display_message(events)
        expect(result).to eq("These events are already in the Calendar, and are up to date.")
      end
    end

    context "with nil" do
      let(:events) {}
      it "returns a failure message" do
        result = Event.display_message(events)
        expect(result).to eq("Could not add event. Please retry.")
      end
    end
  end
end

