@javascript
Feature: Populate calendar with events

  As an admin
  So that I can advertise my events to website vistors
  I want to be able to populate my calendar with events

Background: Events have already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

Scenario: see events on calendar page
  Given I am on the calendar page
  Then I should see the event "Nature Walk" on "March 19, 2015"
  And I should see the event "Green Bean Mixer" on "March 12, 2015"

Scenario: access event details on calendar page
  Given I am on the calendar page
  And I see the event "Nature Walk" on "March 19, 2015"
  When I click the event
  Then I should be on its details page
