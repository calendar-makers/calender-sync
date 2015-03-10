Feature: delete an event and have it removed from the calendar
  As an admin,
  So that I can remove events from the calendar
  I want to be able to delete events from the database

Background: Events have already been added to the database

  Given that I am logged in as "admin"
  And the following events exist:
  | name             | organization       | description                               | date          | time  | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 | 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 | 00:00 | San Francisco City Library |

Scenario: Delete event from the calendar
  When I am on the "Nature Walk" description page
  Then I should see the "Delete" button
  When I click on the "Delete" button
  Then I should be on the calendar page
  And I should not see the "Nature Walk" event
  And I should see ""Nature Walk" event deleted"
