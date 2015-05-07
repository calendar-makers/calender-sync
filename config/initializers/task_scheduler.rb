=begin
scheduler = Rufus::Scheduler.new

scheduler.every '1m', first: Time.now + 20 do |job|
  result = Event.initialize_calendar_db
  if result
    job.unschedule
    puts 'Completed Initial Pull.'
  end
end


scheduler.every '1m', first: Time.now + 2 * 60  do |job|
  if Time.now.min % 30 == 0
    Event.synchronize_past_events
    puts 'Past Events Synchronized.'
  end
  Event.synchronize_upcoming_events
  puts 'Upcoming Events Synchronized.'
end
=end