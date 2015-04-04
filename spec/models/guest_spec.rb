require 'rails_helper'

<<<<<<< HEAD
RSpec.describe Guest, type: :model do
  describe "parse a name pulled from meetup event rsvp" do
=======
describe Guest do

  describe "::parse_meetup_name" do
>>>>>>> a0660ac2106676a243726d02fa3e63287ffd494a
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

  describe "#all_non_anon" do
    let(:guest1) {Guest.new(is_anon: true)}
    let(:guest2) {Guest.new(is_anon: false)}

    before(:each) do
      guest1.save!
      guest2.save!
    end

    it "returns those guests who are not anon" do
      result = guest1.all_non_anon
      expect(result.first).to eq(guest2)
    end
  end

  describe "#all_anon" do
    let(:guest1) {Guest.new(is_anon: true)}
    let(:guest2) {Guest.new(is_anon: false)}

    before(:each) do
      guest1.save!
      guest2.save!
    end

    it "returns those guests who are anon" do
      result = guest1.all_anon
      expect(result.first).to eq(guest1)
    end
  end
end
