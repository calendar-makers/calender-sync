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

end
