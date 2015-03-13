Feature: Populate calendar with events

  As an admin
  So that I can advertise my events to website vistors
  I want to be able to populate my calendar with events

Background: Events have already been added to the database

  Given that the following events exist:
  | name             | organization       | description                               | date          | time  | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 | 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 | 00:00 | San Francisco City Library |

Scenario: see calendar options
  Given I am on the "calendar" page
  Then I should see "Nature Walk" as the "event name"
  Then I should see "Green Bean Mixer" as the "event name"
  And I should see filter/search options
  And I should see calendar navigation tools

Scenario: see events on the calendar page
  Given I am on the calendar page
  Then I should see "Nature Walk" on "April 4"
