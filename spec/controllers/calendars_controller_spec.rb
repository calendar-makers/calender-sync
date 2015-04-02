require 'rails_helper'

describe CalendarsController do


  describe 'gets the calendar' do
    it 'renders the calendar' do
      get :show
      expect(response).to render_template(:show)
    end
  end


  describe 'pulling' do
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

      it 'should call pull with default group_id' do
        expect_any_instance_of(Meetup).to receive(:pull_events).with(no_args)
        get :show
      end

      it 'should display the newly added event names in a message' do
        event_names = ['chester', 'copperpot', 'chunk', 'willy']
        allow(Event).to receive(:make_events_local).and_return(event_names)
        get :show
        expect(flash[:notice]).to eq("Successfully pulled events: #{event_names.join(", ")}")
      end
    end
  end


end