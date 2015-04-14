# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

events = [{ name: 'Gardening', organization: 'Nature in the City',
            start: '1-Jan-2012', description: 'Gardening at San Francisco' },
          { name: 'Green Bean Mixer',  organization: 'Green Thumb',
            start: '3-Mar-2016', description: 'Talk about nature.'},
         ]

events.each do |event|
  Event.create!(event)
end
