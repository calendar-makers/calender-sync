# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

events = [{:name => 'Market Street Prototyping Festival', :organization => 'Nature in the City', :description => 'A walk through the city', :venue_name => 'The Old Town Hall', :st_number => 145, :st_name => 'Jackson st', :city => 'Glendale', :zip => 90210, :start => 'April 09 2016 11:00', :end => 'March 19 2016, 20:30', :how_to_find_us => 'First door on left', :meetup_id => 122121212, :status => 'approved'},
          {:name => 'Nerds on Safari: Market Street', :organization => 'Green Carrots', :description => 'If you like beans youll like this event!', :venue_name => 'San Francisco City Library', :st_number => 45, :st_name => 'Seneca st', :city => 'Phoenix', :zip => 91210, :start => 'April 11 2016 00:00',:end => 'April 21 2016, 8:30', :how_to_find_us => 'Second door on the left', :meetup_id => 656555555, :status => 'approved'},
      ]

events.each do |event|
  Event.create!(event)
end