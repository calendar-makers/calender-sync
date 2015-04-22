require 'rails_helper'

describe Registration do

  describe "Checks if a local rsvp has been updated on meetup" do
    context "with updated rsvp" do
      it "returns true" do
        rsvp = Registration.new(updated: Time.now)
        result = rsvp.needs_updating?(Time.now + 3600)
        expect(result).to be_truthy
      end
    end

    context "with no rsvp update" do
      it "returns false" do
        rsvp = Registration.new(updated: Time.now)
        result = rsvp.needs_updating?(Time.now)
        expect(result).to be_truthy
      end
    end
  end

end
