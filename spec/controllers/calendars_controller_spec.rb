require 'rails_helper'

describe CalendarsController do


  describe 'gets the calendar' do
    it 'renders the calendar' do
      get :show
      expect(response).to render_template(:show)
    end
  end


  describe 'pulling in #show' do
    context 'multiple events' do

      it 'should get remote meetup events' do
        expect(Event).to receive(:get_remote_events).with(no_args)
        get :show
      end

      it 'should make remote meetup events local' do
        events = double()
        allow(Event).to receive(:get_remote_events).and_return(events)
        expect(Event).to receive(:make_events_local).with(events)
        get :show
      end

      it 'should indirectly call pull with default group_id' do
        expect_any_instance_of(Meetup).to receive(:pull_events).with(no_args)
        get :show
      end
=begin
      it 'should display the newly added event names in a message' do
        event_names = ['chester', 'copperpot', 'chunk', 'willy']
        allow(Event).to receive(:make_events_local).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("Successfully pulled events: chester, copperpot, chunk, willy")
      end
=end
    end

    context "with failed result" do
      let(:event_names) {nil}

      it "should display a failure message" do
        allow(Event).to receive(:make_events_local).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("Could not pull events from Meetup")
      end
    end

    context "with zero events returned (i.e. synch status)" do
      let(:event_names) {[]}

      it "should display a failure message" do
        allow(Event).to receive(:make_events_local).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("The Calendar and Meetup are synched")
      end
    end
  end


end