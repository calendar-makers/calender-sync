require 'spec_helper'
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'Checking Show' do
    it "should render 'show' page" do
      event = Event.create(name: 'coyote appreciation',
                           location: 'yosemite',
                           organization: 'nature loving',
                           start: '8-mar-2016',
                           description: 'watch coyotes')
      get :show, { id: 1 }
      expect(response).to render_template(:show)
    end
  end

  describe 'Getting page to add new events' do
    it "should render 'new' page" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'Creating New Event' do
    it 'should redirect to index' do
      post :create, { event: { name: 'coyote appreciation',
                               location: 'yosemite',
                               organization: 'nature loving',
                               start: '8-mar-2016',
                               description: 'watch coyotes' }
                    }
      expect(response).to redirect_to(events_path)
    end
  end

  describe 'Getting page to edit event info' do
    it "should render to 'edit' page" do
      Event.create(name: 'coyote appreciation',
                   location: 'yosemite',
                   organization: 'nature loving',
                   start: '8-mar-2016',
                   description: 'watch coyotes')
      get :edit, { id: 1 }
      expect(response).to render_template(:edit)
    end
  end

  describe 'Updating Event' do
    it 'should redirect to index' do
      event = Event.create(name: 'coyote appreciation',
                           location: 'yosemite',
                           organization: 'nature loving',
                           start: '8-mar-2016',
                           description: 'watch coyotes')
      put :update, { id: 1, event: { name: 'Dog Watch',
                                     location: 'San Francisco',
                                     organization: 'Nature Loving',
                                     start: '8-mar-2016',
                                     description: 'Pet Puppies' }
                   }
      expect(response).to redirect_to(event_path(event))
    end
  end

  describe 'Destroying Event' do
    it 'should delete the selected event' do
      Event.create(name: 'coyote appreciation',
                   location: 'yosemite',
                   organization: 'nature loving',
                   start: '8-mar-2016',
                   description: 'watch coyotes')
      delete :destroy, { id: 1 }
      expect(response).to redirect_to(events_path)
    end
  end



  describe 'pulling rsvps' do

    context 'for single local event' do
      let(:meetup_event_id) {'123'}
      let(:event) {Event.create(name: 'coyote appreciation',
                                location: 'yosemite',
                                organization: 'nature loving',
                                start: '8-mar-2016',
                                description: 'watch coyotes',
                                meetup_id: meetup_event_id)}
      it 'should call merge_rsvps with valid event' do
        expect_any_instance_of(EventsController).to receive(:merge_meetup_rsvps).with(event)
        get :show, id: event.id
      end

      it 'should call get_remote_rsvps with valid event' do
        expect_any_instance_of(EventsController).to receive(:get_remote_rsvps).with(event)
        get :show, id: event.id
      end

      it 'should call pull_rsvps with valid event_id' do
        expect_any_instance_of(Meetup).to receive(:pull_rsvps).with(meetup_event_id)
        get :show, id: event.id
      end
    end

    context 'for single meetup event' do
      let(:meetup_event) {double()}
      #let(:rsvp) {[{:event_id=>"qdwhxgytgbxb", :meetup_id=>82190912, :meetup_name=>"Amber Hasselbring", :invited_guests=>0}]}
      before(:each) do
        allow(Event).to receive(:find).and_return(meetup_event)
        allow(meetup_event).to receive(:id).and_return(1)
        allow(meetup_event).to receive(:meetup_id).and_return('219648262')
        #allow_any_instance_of(Meetup).to receive(:pull_rsvps).with(:string).and_return(rsvp)
      end

      it 'should call merge_rsvps with valid event' do
        expect_any_instance_of(EventsController).to receive(:merge_meetup_rsvps).with(meetup_event)
        get :show, id: meetup_event.id
      end

      it 'should call get_remote_rsvps with valid event' do
        expect_any_instance_of(EventsController).to receive(:get_remote_rsvps).with(meetup_event)
        get :show, id: meetup_event.id
      end

      it 'should call pull_rsvps with valid event_id' do
        expect_any_instance_of(Meetup).to receive(:pull_rsvps).with(meetup_event.meetup_id)
        get :show, id: meetup_event.id
      end

      #it 'should set the flash to display' do
      #  expect(flash[:notice]).to eq("fdf")
      #end
    end
  end
end
