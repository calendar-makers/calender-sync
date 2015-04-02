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

  describe "Checks the number of participants for an event" do
    it "returns the string reporting the total participants" do
      total_participants = 100000
      allow_any_instance_of(Event).to receive(:count_event_participants).and_return(total_participants)
      string = Event.new.generate_participants_message
      expect(string).to eq("The total number of participants, including invited guests, so far is: #{total_participants}")
    end
  end

  describe "Computes the total number of attendees for an event" do
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

  describe "Checks if an event was never pulled from Meetup before" do
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

  describe "Checks if a local event has been updated on meetup" do
    context "with updated event" do
      it "returns true" do
        event = Event.new(updated: Time.now)
        result = event.is_updated?(Time.now + 3600)
        expect(result).to be_truthy
      end
    end

    context "with no event update" do
      it "returns false" do
        event = Event.new(updated: Time.now)
        result = event.is_updated?(Time.now)
        expect(result).to be_truthy
      end
    end
  end

end
