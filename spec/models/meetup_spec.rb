require 'rails_helper'

describe Meetup do
  let(:meetup) {Meetup.new}

  describe '#build_date' do
    let(:date) {Time.gm(2015,4,11,0)}
    let(:date_in_millis) {1428735600000}
    let(:utc_offset) {-25200000}

    it 'gets a time in milliseconds and returns a DateTime' do
      expect(meetup.build_date(date_in_millis, utc_offset)).to eq(date)
    end
  end

  describe '#build_location' do
    let(:data) {{'venue' => {'address_1' => '145 peep st',
                        'city' => 'New York',
                        'zip' => '90210',
                        'state' => 'NY',
                        'country' => 'US'}}}
    let(:location) {[]}
    it 'gets a hash with info and returns a location string' do
      data['venue'].each {|k, v| location << v}
      expect(meetup.build_location(data)).to eq(location.join(', '))
    end
  end

  describe '#parse_event' do
    let(:time) {double}
    let(:location) {double}
    let(:venue) {{id: '123'}}
    let(:data) {{'id' => '123',
                 'name' => 'paul',
                 'description' => 'what not',
                 'group' => {'name' => 'nature'},
                 'time' => time,
                 'updated' => time,
                 'event_url' => 'url',
                 'how_to_find_us' => 'do not',
                 'status' => 'upcoming'}}
    let(:event) {{meetup_id: '123',
                  name: 'paul',
                  description: 'what not',
                  organization: 'nature',
                  location: location,
                  start: time,
                  duration: time,
                  updated: time,
                  url: 'url',
                  how_to_find_us: 'do not',
                  status: 'upcoming'}.merge!(venue)}

    before(:each) do
      allow(meetup).to receive(:build_date).and_return(time)
      allow(meetup).to receive(:build_duration).and_return(time)
      allow(meetup).to receive(:build_location).and_return(location)
      allow(meetup).to receive(:parse_venue).and_return(venue)
    end

    it 'gets a hash with info and returns an event hash' do
      expect(meetup.parse_event(data)).to eq(event)
    end
  end

  describe '#parse_rsvp' do
    let(:time) {double}
    let(:data) {{'event' => {'id' => '123'},
                 'member' => {'member_id' => '123', 'name' => 'pete'},
                 'guests' => '0',
                 'mtime' => time}}
    let(:rsvp) {{event_id: '123',
                 meetup_id: '123',
                 meetup_name: 'pete',
                 invited_guests: '0',
                 updated: time}}

    before(:each) do
      allow(meetup).to receive(:build_date).and_return(time)
    end

    it 'gets a hash with info and returns an rsvp hash' do
      expect(meetup.parse_rsvp(data)).to eq(rsvp)
    end
  end

  describe '#build_duration' do
    let(:data) {{'duration' => 3600000}}
    let(:duration) {1}

    it 'gets a hash with time in milliseconds and returns integer hours' do
      expect(meetup.build_duration(data)).to eq(duration)
    end
  end

  describe '#options_string' do
    let(:options)  {{:id => '22', :weight => '1000', :sweet => 'true'}}
    let(:string) {'id=22&weight=1000&sweet=true'}

    it 'gets a hash of options and returns a string for urls' do
      meetup.options = options
      expect(meetup.options_string).to eq(string)
    end
  end

=begin  REAL CALLS TO API
  describe '#pull_events' do
    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid group id (DEFAULT pull type)' do
        let(:data) {good_user.pull_events}

        it 'returns a possible collection of events' do
          expect(data.size).to be > 0
        end
      end

      context 'with valid event id' do


        it 'returns nil' do
          good_user.options.merge!({event_id: 'invalid_id'})
          data = good_user.pull_events
          expect(data).to be_nil
        end
      end

      context 'with valid group_urlname' do

        it 'returns nil' do
          good_user.options.merge!({event_id: 'invalid_name'})
          data = good_user.pull_events
          expect(data).to be_nil
        end
      end
    end
=end


  describe '#pull_events' do
    let(:data) {double}
    let(:results) {double}
    let(:event) {double}
    let(:events) {[event]}

    before(:each) do
      allow(data).to receive(:parsed_response).and_return(results)
      allow(results).to receive(:[]).with('results').and_return(events)
      allow_any_instance_of(Meetup).to receive(:parse_event).with(any_args).and_return(event)
      allow(HTTParty).to receive(:get).with(any_args).and_return(data)
    end

    context 'with valid authorization key' do
      let(:valid_key) {'some key'}
      let(:good_user) {Meetup.new({key: valid_key})}

      context 'with valid group_urlname' do
        let(:valid_group_urlname) {'group'}

        before(:each) do
          allow(data).to receive(:code).and_return(200)
          allow(events[0]).to receive(:[]).with(:group_urlname).and_return(valid_group_urlname)
          good_user.options[:group_urlname] = valid_group_urlname
        end

        it 'returns the requested events' do
          data = good_user.pull_events
          expect(data[0][:group_urlname]).to eq(valid_group_urlname)
        end
      end

      context 'with invalid group_urlname' do
        let(:invalid_group_urlname) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
          good_user.options[:group_urlname] = invalid_group_urlname
        end

        it 'returns nil' do
          data = good_user.pull_events
          expect(data).to be_nil
        end
      end

      context 'with valid event id' do
        let(:valid_event_id) {"123"}

        before(:each) do
          allow(events[0]).to receive(:[]).with(:meetup_id).and_return(valid_event_id)
          allow(data).to receive(:code).and_return(200)
          good_user.options[:event_id] = valid_event_id
        end

        it 'returns the requested events' do
          data = good_user.pull_events
          expect(data[0][:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid event id' do
        let(:invalid_event_id) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
          good_user.options[:event_id] = invalid_event_id
        end

        it 'returns nil' do
          data = good_user.pull_events
          expect(data).to be_nil
        end
      end

      context 'with valid group id (DEFAULT pull type)' do
        let(:valid_group_id) {"123"}

        before(:each) do
          allow(events[0]).to receive(:[]).with(:group_id).and_return(valid_group_id)
          allow(data).to receive(:code).and_return(200)
          good_user.options[:group_id] = valid_group_id
        end

        it 'returns a possible collection of events' do
          data = good_user.pull_events
          expect(data[0][:group_id]).to eq(valid_group_id)
        end
      end

      context 'with invalid group id (DEFAULT pull type)' do
       # it can never be invalid
      end
    end


    context 'with invalid authorization' do
      let(:invalid_key) {'invalid'}
      let(:bad_user) {Meetup.new({key: invalid_key})}

      before(:each) do
        allow(data).to receive(:code).and_return(401)
      end

      it 'returns nil' do
        data = bad_user.pull_events
        expect(data).to be_nil
      end
    end
  end



=begin  REAL CALLS TO API
  describe '#pull_event' do
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
=end


  describe '#pull_event' do
    let(:valid_event_id) {"123"}
    let(:data) {double}
    let(:results) {double}
    let(:event) {double}

    before(:each) do
      allow(data).to receive(:parsed_response).and_return(results)
      allow_any_instance_of(Meetup).to receive(:parse_event).with(results).and_return(event)
      allow(event).to receive(:[]).with(:meetup_id).and_return(valid_event_id)
      allow(HTTParty).to receive(:get).with(any_args).and_return(data)
    end

    context 'with valid authorization key' do
      let(:valid_key) {'some_key'}
      let(:good_user) {Meetup.new({key: valid_key})}

      context 'with valid id' do
        before(:each) do
          allow(data).to receive(:code).and_return(200)
        end

        it 'returns the requested event' do
          data = good_user.pull_event(valid_event_id)
          expect(data[:meetup_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid id' do
        let(:invalid_event_id) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
        end

        it 'returns nil' do
          data = good_user.pull_event(invalid_event_id)
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:invalid_key) {'invalid'}
      let(:bad_user) {Meetup.new({key: invalid_key})}

      before(:each) do
        allow(data).to receive(:code).and_return(401)
      end

      it 'returns nil' do
        data = bad_user.pull_event(valid_event_id)
        expect(data).to be_nil
      end
    end
  end

=begin  REAL CALLS TO API
  describe '#pull_rsvps' do
    let(:valid_event_id) {'219648262'}

    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38'})}

      context 'with valid event id' do
        let(:data) {good_user.pull_rsvps(valid_event_id)}

        it 'returns a possible collection of rsvps' do
         expect(data[0][:event_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid event id' do
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
=end

  describe '#pull_rsvps' do
    let(:valid_event_id) {"123"}
    let(:data) {double}
    let(:results) {double}
    let(:rsvp) {double}
    let(:rsvps) {[rsvp]}

    before(:each) do
      allow(data).to receive(:parsed_response).and_return(results)
      allow(results).to receive(:[]).with('results').and_return(rsvps)
      allow_any_instance_of(Meetup).to receive(:parse_rsvp).with(any_args).and_return(rsvp)
      allow(HTTParty).to receive(:get).with(any_args).and_return(data)
      allow(rsvp).to receive(:[]).with(:event_id).and_return(valid_event_id)
    end

    context 'with valid authorization key' do
      let(:valid_key) {'some key'}
      let(:good_user) {Meetup.new({key: valid_key})}

      context 'with valid event id' do
        before(:each) do
          allow(data).to receive(:code).and_return(200)
        end

        it 'returns a possible collection of rsvps' do
          data = good_user.pull_rsvps(valid_event_id)
          expect(data[0][:event_id]).to eq(valid_event_id)
        end
      end

      context 'with invalid event id' do
        let(:invalid_event_id) {'invalid'}

        before(:each) do
          allow(data).to receive(:code).and_return(401)
        end

        it 'returns nil' do
          data = good_user.pull_rsvps(invalid_event_id)
          expect(data).to be_nil
        end
      end
    end

    context 'with invalid authorization' do
      let(:invalid_key) {'invalid'}
      let(:bad_user) {Meetup.new({key: invalid_key})}

      before(:each) do
        allow(data).to receive(:code).and_return(401)
      end

      it 'returns nil' do
        data = bad_user.pull_rsvps(valid_event_id)
        expect(data).to be_nil
      end
    end
  end

  ####################################################################

  describe '#push_event' do
    context 'with valid authorization key' do
      let(:good_user) {Meetup.new({key: '3837476f222cc2b6b365513821d38', group_id:'1556336',
                                  group_urlname:'Meetup-API-Testing'})}
      let(:event) {Event.new(name: 'Swimming', venue_name: 'Moraga Steps', address_1: '16th Ave & Moraga St',
                                 city: 'San Francisco', zip: '94111')}

      context 'with existing local event' do
        let(:data) {good_user.push_event(event)}

        it 'returns a possible collection of events' do
          expect(data).to be_truthy
        end
      end

      context 'with invalid organization id' do
        let(:data) {good_user.pull_events}

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


  describe "::get_event_venue_data" do
    context "from a valid event" do
      let(:event) {Event.new(venue_name: 'Playa', address_1: '145 Peeep st.',
                                city: 'Gendale', zip: '6789',
                                state: 'CA', country: 'USA')}
      it "returns a hash of venue fields" do
        result = Meetup.get_event_venue_data(event)
        expect(result).to eq({name: 'Playa', address_1: '145 Peeep st.',
                              city: 'Gendale', zip: '6789',
                              state: 'CA', country: 'USA'})
      end
    end

    context "from an invalid event" do
      it "returns nothing" do
        result = Meetup.get_event_venue_data(nil)
        expect(result).to be_empty
      end
    end
  end

  describe "#parse_venue" do
    let(:meetup) {Meetup.new}

    context "from valid API-sent data" do
      let(:data) {{'venue'=> {'name' => 'Plaza', 'address_1'=> '145 Peeep st.',
                                 'city'=> 'Gendale', 'zip'=> '6789',
                                 'state'=> 'CA', 'country'=> 'USA'}}}

      it "returns a hash of venue fields" do
        result = meetup.parse_venue(data)
        expect(result).to eq({venue_name: 'Plaza', address_1: '145 Peeep st.',
                              city: 'Gendale', zip: '6789',
                              state: 'CA', country: 'USA'})
      end
    end

    context "from invalid data" do
      it "returns nothing" do
        result = meetup.parse_venue(nil)
        expect(result).to be_empty
      end
    end
  end

  describe "#get_event_data" do
    let(:meetup) {Meetup.new}
    let(:id) {123}
    let(:event) {{name: 'Nature', description: 'Nice one',
                  start: Time.now, duration: '2', how_to_find_us: 'do not'}}

    it "returns a hash of venue fields" do
      allow_any_instance_of(Meetup).to receive(:get_meetup_venue_id).and_return(id)
      result = meetup.get_event_data(event)
      expect(result).to eq({name: 'Nature', description: 'Nice one',
                               venue_id: id, time: Time.now.to_i,
                               duration: '2', how_to_find_us: 'do not'})
    end
  end

  describe "#create_venue" do
    let(:new_event) {Event.new(venue_name: 'Pepperpot', address_1: '145 Jackson st',
                           city: 'Moon', zip: '94111',
                           state: 'CA', country: 'us')}
    let(:old_event) {Event.new(venue_name: 'Moraga Steps', address_1: '16th Ave & Moraga St',
                               city: 'San Francisco', zip: '94111',
                               state: 'CA', country: 'us')}
    let(:invalid_event) {Event.new(venue_name: 'Moraga Steps', address_1: '',
                               city: 'Sa', zip: '94111',
                               state: 'CA', country: 'us')}

    let(:data) {double}


    context "with valid key" do
      let(:good_user) {Meetup.new(group_urlname: 'Meetup-API-Testing')}
      before(:each) do
        allow(HTTParty).to receive(:post).and_return(data)
      end

      it "gets a response from meetup with new venue data" do
        allow(data).to receive(:code).and_return(201)
        response = good_user.create_venue(new_event)
        expect(response.code).to eq(201)
      end

      it "gets a response from meetup with old venue data" do
        allow(data).to receive(:code).and_return(409)
        response = good_user.create_venue(old_event)
        expect(response.code).to eq(409)
      end

      it "gets a response from meetup with failure" do
        allow(data).to receive(:code).and_return(400)
        response = good_user.create_venue(invalid_event)
        expect(response.code).to eq(400)
      end
    end

    context "with invalid key" do
      let(:bad_user) {Meetup.new(group_urlname: 'Meetup-API-Testing', key:'wrongkey')}
      before(:each) do
        allow(HTTParty).to receive(:post).and_return(data)
        allow(data).to receive(:code).and_return(401)
      end

      it "gets a not authorized error response from meetup" do
        response = bad_user.create_venue(new_event)
        expect(response.code).to eq(401)
      end

    end
  end

  describe "#get_meetup_venue_id" do
    let(:new_event) {Event.new(venue_name: 'Pepperpot', address_1: '145 Jackson st',
                               city: 'Moon', zip: '94111',
                               state: 'CA', country: 'us')}
    let(:old_event) {Event.new(venue_name: 'Moraga Steps', address_1: '16th Ave & Moraga St',
                               city: 'San Francisco', zip: '94111',
                               state: 'CA', country: 'us')}
    let(:invalid_event) {Event.new(venue_name: 'Moraga Steps', address_1: '',
                                   city: 'Sa', zip: '94111',
                                   state: 'CA', country: 'us')}
    let(:id) {'1234'}
    let(:data) {double}
    let(:response) {double}


    context "with valid key" do
      let(:good_user) {Meetup.new(group_urlname: 'Meetup-API-Testing')}
      before(:each) do
        allow(good_user).to receive(:create_venue).and_return(data)
      end

      it "gets a response from meetup with new venue data" do
        allow(data).to receive(:code).and_return(201)
        allow(data).to receive(:parsed_response).and_return(response)
        allow(response).to receive(:[]).and_return(id)
        response = good_user.get_meetup_venue_id(new_event)
        expect(response).to eq(id)
      end

      it "gets a response from meetup with old venue data" do
        errors = double
        error =  double
        venue = double
        allow(data).to receive(:code).and_return(409)
        allow(data).to receive(:parsed_response).and_return(response)
        allow(response).to receive(:[]).with('errors').and_return(errors)
        allow(errors).to receive(:[]).with(0).and_return(error)
        allow(error).to receive(:[]).with('potential_matches').and_return(venue)
        allow(venue).to receive(:[]).with('id').and_return(id)
        response = good_user.get_meetup_venue_id(old_event)
        expect(response).to eq(id)
      end

      it "gets a response from meetup with failure" do
        allow(data).to receive(:code).and_return(400)
        response = good_user.get_meetup_venue_id(invalid_event)
        expect(response).to eq('')
      end
    end

    context "with invalid key" do
      let(:bad_user) {Meetup.new(group_urlname: 'Meetup-API-Testing', key:'wrongkey')}
      before(:each) do
        allow(bad_user).to receive(:create_venue).and_return(data)
        allow(data).to receive(:code).and_return(401)
      end

      it "gets a not authorized error response from meetup" do
        response = bad_user.get_meetup_venue_id(new_event)
        expect(response).to eq('')
      end

    end

  end



end

