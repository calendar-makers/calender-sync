require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe "parse a name pulled from meetup event rsvp" do
    context "with a name including both first and last" do
      let(:good_name) {'Chester Copperpot'}

      it "returns both first and last" do
      result = Guest::parse_meetup_name(good_name)
      expect(result).to eq(['Chester', 'Copperpot'])
      end
    end

    context "with a name with no distinct first and last" do
      let(:bad_name) {'Chester'}

      it "returns the first and an empty last" do
      result = Guest::parse_meetup_name(bad_name)
      expect(result).to eq(['Chester', ''])
      end
    end

  end
end
