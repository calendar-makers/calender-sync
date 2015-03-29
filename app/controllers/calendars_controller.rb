class CalendarsController < ApplicationController

  def show

    event_names = create_local_events(get_remote_events)

    if event_names
      flash[:notice] = "Successfully pulled events: #{event_names}"
    else
      flash[:notice] = "Could not pull events from Meetup"
    end

    redirect_to events_path

  end

  def get_remote_events
    # Here we can pass the token to the API call if needed.
    # If so put them in the options hash, and pass it to the constructor

    #options = {access_token: token}
    meetup = Meetup.new()
    meetup_events = meetup.pull_events
    candidate_events = []
    meetup_events.each do |event|
      return nil unless Event.is_valid?(event)
      candidate_events << Event.new(event)
    end
    candidate_events
  end


  def create_local_events(events)
    if events
      names = []
      events.each do |event|
        if event.is_new?
          event.save!
        elsif event.is_updated?
          event.update_attributes!
        else # already stored
          next
        end
        names << event[:name]
      end
      names
    end
  end

end
