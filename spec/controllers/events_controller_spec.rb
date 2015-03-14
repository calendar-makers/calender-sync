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
      post :create, { name: 'coyote appreciation',
                      location: 'yosemite',
                      organization: 'nature loving',
                      start: '8-mar-2016',
                      description: 'watch coyotes' }
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
      put :update, { id: 1 }, { name: 'Dog Watch' }
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
end
