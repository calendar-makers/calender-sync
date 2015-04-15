@javascript
Feature: Populate calendar with events

  As an admin
  So that I can advertise my events to website vistors
  I want to be able to populate my calendar with events

Background: Events have already been added to the database

  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | address_1      | city     | zip   | start                | end                  | how_to_find_us     |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145 Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45 Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left|

  Scenario: see events on calendar page
  Given I am on the calendar page
  Then I should see the event "Nature Walk" on "March 19, 2015"
  And I should see the event "Green Bean Mixer" on "April 20, 2015"

Scenario: access event details on calendar page
  Given I am on the calendar page
  And I see the event "Nature Walk" on "March 19, 2015"
  When I click the event
  Then I should be on its details page
