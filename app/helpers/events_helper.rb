module EventsHelper
  # Represents an html element
  def elem
    @elem ||= nil
  end

  # Alternates the class for the calling html element
  def determine_class(prev)
    prev == 'colored' ? (@elem = "") : (@elem = 'colored')
  end

  # Gives 1 hour from now
  def next_hour
    DateTime.now + 1.hour
  end

  # Time to display for a new event form
  # It displays the next hour from now
  def default_time
    time = next_hour
    {
      hour: time.hour,
      minute: 0,
      day: time.day,
      month: time.month,
      year: time.year
    }
  end
end