require 'rails_helper'

describe CalendarsController do

=begin
  I THINK JAVASCRIPT IS MESSIGN THIS UP
  describe 'gets the calendar' do
    it 'renders the calendar' do     ############
      expect(response).to redirect_to(events_path)  # UNTIL WE SWITCH TO THE CALENDAR
      get :show                      ############
    end
  end
=end

  describe 'pulling' do
    context 'multiple events' do
      it 'should call pull with default group_id' do
        expect_any_instance_of(Meetup).to receive(:pull_events).with(no_args)
        get :show
      end
    end
  end


end