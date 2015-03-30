class CalendarsController < ApplicationController

  def show
    event_names = make_events_local(get_remote_events)

    if event_names.nil?
      flash[:notice] = "Could not pull events from Meetup"
    elsif event_names.empty?
      flash[:notice] = "The Calendar and Meetup are synched"
    else
      flash[:notice] = "Successfully pulled events: #{event_names.join(', ')}"
    end

    # later redirect to calendar
    redirect_to events_path
  end

  def get_remote_events
    # Here we can pass the token to the API call if needed.
    # We can also pass any options for the query
    # If so put them in the options hash, and pass it to the constructor

    #options = {access_token: token}
    meetup = Meetup.new

    candidate_events = []
    meetup_events = meetup.pull_events
    if meetup_events
      meetup_events.each do |event|
        return nil unless true   # ANY VALIDATION???? Check meetup.rb for details
        candidate_events << Event.new(event)
      end
    end

    candidate_events
  end


  def make_events_local(events)
    if events
      names = []
      events.each do |event|
        if event.is_new?
          event.save!
        elsif event.is_updated?(event[:updated])
          stored_event = Event.find_by_meetup_id(event[:meetup_id])
          stored_event.update_attributes!(event.attributes)
        else # already stored and unchanged since
          next
        end

        names << event[:name]
      end

      names
    end
  end

end
