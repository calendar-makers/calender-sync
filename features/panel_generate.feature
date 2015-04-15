Feature:
  As a user or admin
  to interact with the events
  I want to see an event panel beside the calendar

Background: events are loaded into database
  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | April 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | April 12 2015 00:00 | San Francisco City Library |

Scenario: see the panel
  Given I am on the calendar page
  Then I should see the default panel
