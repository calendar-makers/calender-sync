Feature: Show event details on the webpage for a particular event
  As a website visitor
  So that I can find details about the event
  I want to be able to visit the event page
  And be able to return to the calendar page when I am done

Background: Events have already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

Scenario: user clicks on link to get to event details
  Given I am on the "Events Directory" page
  And "Green Bean Mixer" exists
  When I click on the "Green Bean Mixer" link
  Then I should be on the "details" page for "Green Bean Mixer"

Scenario: user is on an event page
  Given I am on the "details" page for "Nature Walk"
  Then I should see "Nature Walk" as the "name"
  And I should see "Nature in the City" as the "organization"
  And I should see "4:30pm" as the "time"
  And I should see "March 19, 2015" as the "date"
  And I should see "A walk through the city" as the "description"
  And I should see "The old Town Hall" as the "location"

Scenario: user going from event page back to calendar page
  Given I am on the "details" page for "Nature Walk"
  When I click on the "Back to calendar" link
  Then I should be on the "Events Directory" page   
