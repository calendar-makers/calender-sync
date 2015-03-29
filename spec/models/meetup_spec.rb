require 'rails_helper'

describe Meetup do
  let(:meetup) {Meetup.new}

  describe 'computes a date from input data' do
    it 'gets a time in milliseconds and returns a DateTime' do
      date = Time.utc(2000, 'jan', 1, 20, 15, 1)
      date_in_millis = date.to_i * 1000
      expect(meetup.build_date(date_in_millis)).to eq(date)
    end
  end

  describe 'builds location from input data' do
    it 'gets a hash with info and returns a location string' do
      data = {'venue' => {'address_1' => '145 peep st',
                          'city' => 'New York',
                          'zip' => '90210',
                          'state' => 'NY',
                          'country' => 'US'}}
      location = []
      data['venue'].each {|k, v| location << v}
      expect(meetup.build_location(data)).to eq(location.join(', '))
    end
  end

  describe 'builds duration from input data' do
    it 'gets a hash with time in milliseconds and returns integer hours' do
      data = {'duration' => 3600000}
      result = 1
      expect(meetup.build_duration(data)).to eq(result)
    end
  end

  describe 'creates the query list of options' do
    it 'gets a hash of options and returns a string for urls' do
      meetup.options = {:id => '22', :weight => '1000', :sweet => 'true'}
      result = "id=22&weight=1000&sweet=true"
      expect(meetup.options_string).to eq(result)
    end
  end

  describe 'pulls events' do
    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid organization id' do
        let(:data) {good_user.pull_events}

        it 'returns a possible collection of events' do
          expect(data.size).to be > 0
        end
      end

      context 'with invalid organization id' do
        let(:data) {good_user.pull_events('invalid_id')}

        it 'returns nil' do
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_id'})}
      let(:data) {bad_user.pull_events}

      it 'returns nil' do
        expect(data).to be_nil
      end
    end
  end

  describe 'pulls 1 event' do
    let(:valid_event_id) {"219648262"}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid event id' do
        let(:data) {good_user.pull_event(valid_event_id)}

        it 'returns the requested event' do
          expect(data[:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid organization id' do
        let(:data) {good_user.pull_event('invalid_id')}

        it 'returns nil' do
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_key'})}
      let(:data) {bad_user.pull_event(valid_event_id)}

      it 'returns nil' do
        expect(data).to be_nil
      end
    end
  end


  describe 'pulls rsvps' do
    let(:valid_event_id) {"219648262"}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid event id' do
        let(:data) {good_user.pull_rsvps(valid_event_id)}

        it 'returns the requested rsvp' do
         # expect(data[:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid organization id' do
        let(:data) {good_user.pull_rsvps('invalid_id')}

        it 'returns nil' do
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:bad_user) {Meetup.new({key: 'invalid_key'})}
      let(:data) {bad_user.pull_rsvps(valid_event_id)}

      it 'returns nil' do
        expect(data).to be_nil
      end
    end
  end


end

