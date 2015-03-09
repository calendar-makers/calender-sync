Feature: Populate calendar with events

  As an admin
  So that I can advertise my events to website vistors
  I want to be able to populate my calendar with events

Background: Events have already been added to the database

  Given that the following events exist:
  | organization       | event_name       | details                                   | date       | time  | location
  | Nature in the City | Nature Walk      | A walk through the city                   | 19:03:2015 | 16:30 | The old Town Hall
  | Green Carrots      | Green Bean Mixer | If you like beans you'll like this event! | 12:03:2015 | 00:00 | San Francisco City Library

Scenario: see calendar options
  When I click on the calendar page
  Then I should see events in the calendar
  And I should see filter/search options
  And I should see calendar navigation tools

Scenario: see events on the calendar page
  Given I am on the calendar page
  Then I should see "Nature Walk" on "April 4"
