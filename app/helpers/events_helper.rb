module EventsHelper
  # Represents the an html element
  def elem
    @elem ||= nil
  end

  # Alternates the class for the calling html element
  def determine_class(prev)
    prev == 'colored' ? (@elem = "") : (@elem = 'colored')
  end
end