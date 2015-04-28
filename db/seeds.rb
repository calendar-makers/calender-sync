# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

events = [{ name: 'Gardening', organization: 'Nature in the City',
            start: 'March 19 2015, 16:30', end: 'March 19 2015, 20:30',  description: 'Gardening at San Francisco',
            how_to_find_us: 'first door to the left', venue_name: 'The Old Town Hall', address_1: '145 Jackson st',
            city: 'Glendale', zip: '90210'},

          { name: 'Green Bean Mixer',  organization: 'Green Thumb',
            start: 'April 20 2015, 8:30', end: 'April 21 2015, 8:30', description: 'Talk about nature.',
            how_to_find_us: 'first door to the right', venue_name: 'San Francisco Library', address_1: '35 Seneca st',
            city: 'New York', zip: '91211'}]

events.each do |event|
  Event.create!(event)
end

#Is this safe?
User.create!(email: "amber@natureinthecity.org", password: "password", level: 0)
User.create!(email: "admin@admin.com", password: "password", level: 0)
User.create!(email: "vincehayashi@berkeley.edu", password: "password", level: 0)
