Feature: delete an event and have it removed from the calendar
  As an admin,
  So that I can remove events from the calendar
  I want to be able to delete events from the database

Background: Events have already been added to the database

  Given that I am logged in as "admin"
  And the following events exist:
  | organization       | event_name       | details                                   | date            | location
  | Nature in the City | Nature Walk      | A walk through the city                   | 1630:19:03:2015 | The old Town Hall
  | Green Carrots      | Green Bean Mixer | If you like beans you'll like this event! | 0000:12:03:2015 | San Francisco City Library

Scenario: Delete event from the calendar
  When I am on the "Nature Walk" description page
  Then I should see the "Delete" button
  When I click on the "Delete" button
  Then I should be on the calendar page
  And I should not see the "Nature Walk" event
  And I should see ""Nature Walk" event deleted"
