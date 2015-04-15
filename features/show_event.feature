Feature: Show event details on the webpage for a particular event
  As a website visitor
  So that I can find details about the event
  I want to be able to visit the event page
  And be able to return to the calendar page when I am done

Background: Events have already been added to the database

  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | address_1      | city     | zip   | start                | end                  | how_to_find_us     |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145 Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45 Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left|

  Scenario: user clicks on link to get to event details
  Given I am on the "Events Directory" page
  And "Green Bean Mixer" exists
  When I click on the "Green Bean Mixer" link
  Then I should be on the "details" page for "Green Bean Mixer"

Scenario: user is on an event page
  Given I am on the "details" page for "Nature Walk"
  Then I should see "Nature Walk" as the "name"
  And I should see "Nature in the City" as the "organization"
  And I should see "March 19, 2015 at 4:30pm" as the "start"
  And I should see "A walk through the city" as the "description"

Scenario: user going from event page back to calendar page
  Given I am on the "details" page for "Nature Walk"
  When I click on the "Back to calendar" link
  Then I should be on the "Calendar" page
