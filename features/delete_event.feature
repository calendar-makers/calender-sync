Feature: delete an event and have it removed from the calendar
  As an admin,
  So that I can remove events from the calendar
  I want to be able to delete events from the database

Background: Events have already been added to the database

  #Authentication not yet implemented
  Given I am logged in as the admin
  And the following events exist:
    | name             | organization       | description                               | venue_name                 | address_1      | city     | zip   | start                | end                  | how_to_find_us     |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145 Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45 Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left|

  Scenario: Delete event from the calendar
  Given I am on the "details" page for "Nature Walk"
  And I should see the "Delete" button
  When I click on the "Delete" button
  Then I should be on the "Calendar" page
  And I should not see the "Nature Walk" link
  And I should see "'Nature Walk' was successfully removed" on the page
