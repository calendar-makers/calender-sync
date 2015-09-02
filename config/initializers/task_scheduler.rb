unless Rails.env.test?
  DEBUG = true

  WebScraper.instance.fetch_page_data

  scheduler = Rufus::Scheduler.new

  ##
  # This loop will continue until the database initialization is successful
  #
  scheduler.every '1m', first: Time.now + 5 do |job|
    result = Event.initialize_calendar_db
    if result
      job.unschedule
      puts 'Completed Initial Pull.' if DEBUG
    else
      puts 'FAILED INITIAL PULL.' if DEBUG
    end
  end


  scheduler.every '1m', first: Time.now + 2 * 60  do |job|
    minutes = Time.now.min
    if minutes % 5 == 0
      WebScraper.instance.fetch_page_data
      puts 'Joomla Data Fetched.' if DEBUG
      if minutes % 30 == 0
        Event.synchronize_past_events
        puts 'Past Events Synchronized.' if DEBUG
      end
    end

    Event.synchronize_upcoming_events
    puts 'Upcoming Events Synchronized.' if DEBUG
  end
end