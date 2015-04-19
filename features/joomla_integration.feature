Feature: Have our calendar integrate with Joomla template
  As a user
  So that when I navigate to the calendar page
  The style of the page remains consistent with the rest of the Joomla site

Background: Events have already been added to the database

  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | address_1      | city     | zip   | start                | end                  | how_to_find_us     |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145 Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45 Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left|

Scenario: user is on calendar page
Given I am on the "Calendar" page
Then I should see "Home" on the page

Scenario: sad path
Given there is an error requesting the joomla site
And I am on the "Calendar" page
Then I should see "Home" on the page
