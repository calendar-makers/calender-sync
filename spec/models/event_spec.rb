require 'spec_helper'
require 'rails_helper'

RSpec.describe Event, type: :model do
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
    let(:formatted_date) {'Oct 30, 2002 at  4:02pm'}

    it "returns the date in a simpler form" do
      event = Event.new(start: date)
      result = event.format_start_date
      expect(result).to eq(formatted_date)
    end
  end

  describe "#format_end_date" do
    let(:date) {Time.utc(2002, 10, 31, 0, 2)}
    let(:formatted_date) {'Oct 30, 2002 at  4:02pm'}

    it "returns the date in a simpler form" do
      event = Event.new(end: date)
      result = event.format_end_date
      expect(result).to eq(formatted_date)
    end
  end

  describe ".process_remote_events" do
    let(:event) {[Event.new]}

    context "with new events" do
      it "saves the event in the db" do
        expect_any_instance_of(Event).to receive(:save)
        Event.process_remote_events(event)
      end
    end

    context "with an updated event" do
      it "updates an already stored event with the fields of the input event" do
        event[0][:meetup_id] = '123'
        event[0][:updated] = Time.now + 200000
        old_event = Event.new(updated: Time.now, meetup_id: '123')

        allow(Event).to receive(:find_by_meetup_id).with('123').and_return(old_event)
        expect(old_event).to receive(:apply_update)
        Event.process_remote_events(event)
      end
    end

    context "with an old event" do
      it "does nothing for an old unchanged event" do
        event[0][:meetup_id] = '123'
        event[0][:updated] = Time.now
        stored_event = Event.new(updated: Time.now, meetup_id: '123')

        allow(Event).to receive(:find_by_meetup_id).with('123').and_return(stored_event)
        expect(stored_event).not_to receive(:apply_update)
        Event.process_remote_events(event)
      end
    end
  end

  describe "#merge_meetup_rsvps" do
    let(:event) {Event.new(id: 1)}
    let(:rsvp) {[{event_id:"qdwhxgytgbxb", meetup_id:82190912,
                  meetup_name:"Amber Hasselbring", invited_guests:0,
                  updated: Time.now}]}
    let(:guest) {Guest.new(id: 1, first_name: 'chester', last_name: 'copperpot')}

      before(:each) do
        allow_any_instance_of(Event).to receive(:get_remote_rsvps).and_return(rsvp)
        allow(Guest).to receive(:find_by_meetup_rsvp).and_return(guest)
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

  describe '#location' do
    let(:location) {[]}

    it 'returns a complete location string' do
      location_data = {'st_number' => '145', 'st_name' => 'peep st', 'city' => 'New York',
                            'zip' => '90210', 'state' => 'NY', 'country' => 'US'}
      event = Event.new(location_data)
      location_data.each {|k, v| location << v}
      expect(event.location).to eq("145 peep st, New York, NY 90210, US")
    end

    it 'handles nil state fields' do
      location_data = {'st_number' => '145', 'st_name' => 'peep st', 'city' => 'New York',
                       'zip' => '90210', 'state' => nil, 'country' => 'US'}
      event = Event.new(location_data)
      expect(event.location).to eq("145 peep st, New York, 90210, US")
    end

  end

  describe '.remove_remotely_deleted_events' do
    before(:each) do
      @event_1 = Event.create!(meetup_id: '12345', start: DateTime.now)
      @event_2 = Event.create!(meetup_id: '678910', start: DateTime.now)
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

    context 'with one remote addition' do
      let(:new_event) {Event.create!(meetup_id: '55555555')}
      let(:remote_events) {[@event_1, new_event]}

      it 'does nothing' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.all.size).to eq(@local_events.size)
      end
    end

    context 'with one remote addition' do
      let(:new_event) {Event.create!(meetup_id: '55555555')}
      let(:remote_events) {[@event_1, new_event]}

      it 'does nothing' do
        Event.remove_remotely_deleted_events(remote_events)
        expect(Event.all.size).to eq(@local_events.size)
      end
    end
  end

  describe '.get_remotely_deleted_ids' do
    before(:each) do
      @event_1 = Event.create!(meetup_id: '12345', start: DateTime.now)
      @event_2 = Event.create!(meetup_id: '678910', start: DateTime.now)
      @local_events = [@event_1, @event_2]
    end

    context 'with no remote deletions' do
      let(:remote_events) {@local_events}

      it 'returns empty id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq([])
      end
    end

    context 'with one remote deletion (@event_2)' do
      let(:remote_events) {[@event_1]}

      it 'returns the id of @event_2' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq(['678910'])
      end
    end

    context 'with equal events but one remote addition' do
      let(:new_event) {Event.create!(meetup_id: '55555555')}
      let(:remote_events) {@local_events.concat [new_event]}

      it 'returns empty id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq([])
      end
    end

    context 'with all remote events deleted' do
      let(:remote_events) {[]}

      it 'returns full local id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq(["12345", "678910"])
      end
    end

    context 'with no local events' do
      let(:remote_events) {@local_events}

      before(:each) do
        @local_events.each {|event| event.destroy!}
      end

      it 'return empty id list' do
        ids = Event.get_remotely_deleted_ids(remote_events)
        expect(ids).to eq([])
      end
    end
  end



  describe ".get_requested_ids" do
    let(:data) {{event123: "1", e123vent: "2", evenABC: "3", event: "4", event12abc: "5"}}
    it "Selects only ids which match /^event.*/" do
      result = Event.get_requested_ids(data)
      expect(result).to eq([:event123, :event12abc])
    end
  end

  describe ".cleanup_ids" do
    let(:dirty_ids) {['event123', 'event1456', 'eventABC']}
    let(:clean_ids) {['123', '1456', 'ABC']}

    it 'should return only pure ids' do
      result = Event.cleanup_ids(dirty_ids)
      expect(result).to eq(clean_ids)
    end
  end

  describe '.initialize_calendar_db' do
    let(:event1) {Event.new(meetup_id: '123565')}
    let(:event2) {Event.new(meetup_id: '653434')}
    let(:event3) {Event.new(meetup_id: '5654334')}
    let(:upcoming_events) {[event1]}
    let(:past_events) {[event2, event3]}


    context 'with both past and upcoming events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_upcoming_events).and_return(upcoming_events)
      end

      it 'returns sum of events' do
        result = Event.initialize_calendar_db
        expect(result).to eq(upcoming_events + past_events)
      end
    end

    context 'with only past events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_upcoming_events).and_return(nil)
      end

      it 'returns nothing' do
        result = Event.initialize_calendar_db
        expect(result).to be_nil
      end
    end

    context 'with only upcoming events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_upcoming_events).and_return(upcoming_events)
      end

      it 'returns sum of events' do
        result = Event.initialize_calendar_db
        expect(result).to be_nil
      end
    end

    context 'with no events at all' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_upcoming_events).and_return(nil)
      end

      it 'returns sum of events' do
        result = Event.initialize_calendar_db
        expect(result).to be_nil
      end
    end
  end

  describe '.get_past_events' do
    let(:events) {[double, double]}
    before(:each) do
      allow(Event).to receive(:get_remote_events).and_return(events)
    end

    it 'calls get_remote_events with the right params' do
      expect(Event).to receive(:get_remote_events).with({status: 'past', time: '-1,'})
      Event.get_past_events(-1)
    end
  end

  describe '.synchronize_past_events' do
    let(:event1) {Event.new(meetup_id: '123565', organization: 'Nature in the City')}
    let(:third1) {Event.new(meetup_id: '653434', organization: 'Nature')}
    let(:third2) {Event.new(meetup_id: '5654334', organization: 'Flower')}
    let(:past_events) {[event1]}
    let(:third_events) {[third1, third2]}


    context 'with both past and upcoming events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_past_third_party_events).and_return(third_events)
      end

      it 'returns sum of events' do
        result = Event.synchronize_past_events
        expect(result).to eq(past_events + third_events)
      end
    end

    context 'with only past events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(past_events)
        allow(Event).to receive(:get_past_third_party_events).and_return(nil)
      end

      it 'returns nothing' do
        result = Event.synchronize_past_events
        expect(result).to be_nil
      end
    end

    context 'with only third party events' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_past_third_party_events).and_return(third_events)
      end

      it 'returns nothing' do
        result = Event.synchronize_past_events
        expect(result).to be_nil
      end
    end

    context 'with no events at all' do
      before(:each) do
        allow(Event).to receive(:get_past_events).and_return(nil)
        allow(Event).to receive(:get_past_third_party_events).and_return(nil)
      end

      it 'returns sum of events' do
        result = Event.synchronize_past_events
        expect(result).to be_nil
      end
    end
  end
  
  describe ".tags" do
    context "when no tags are true" do
      it "should return and empty string"
      it "should not error"
    end
    
    context "when tags are true" do
      it "should return the names of true tag values"
      it "should not error"
    end
  end

end

