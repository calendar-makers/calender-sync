scheduler = Rufus::Scheduler.new

scheduler.every '1m', first: :now do |job|
  result = Event.initialize_calendar_db
  if result
    job.unschedule
    puts 'Completed Initial Pull.'
  end
end


scheduler.every '1h', first: Time.now + 5 * 60  do |job|
  Event.synchronize_past_events
  puts 'Past Events Synchronized.'
end