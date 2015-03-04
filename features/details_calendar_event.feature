Feature: Show event details on the webpage for a particular event.
  As a website vistor
  So that I can find details about the event
  I want to be able to visit the event page
  And be able to return to the calendar page when I am done

Background: Events have already been added to the database

  Given that the following events exist:
  | organization       | event_name       | details                                   | date            | location
  | Nature in the City | Nature Walk      | A walk through the city                   | 1630:19:03:2015 | The old Town Hall
  | Green Carrots      | Green Bean Mixer | If you like beans you'll like this event! | 0000:12:03:2015 | San Francisco City Library

Scenario: user clicks on link to get to event details
  Given I am on the calendar page
  And "Green Bean Mixer" exists
  When I click on "Green Bean Mixer"
  Then I should be on the "Grean Bean Mixer" description page

Scenario: user is on an event page
  Given I am on the "Nature Walk" page
  Then I should see the organization "Nature in the City"
  And I should see the event name "Nature Walk"
  And I should see the time and date "4:30pm, March 19, 2015"
  And I should see the description "A walk through the city"
  And I should see the location "The old Town Hall"

Scenario: user going from event page back to calendar page
  Given I am on the "Nature Walk" page
  When I click on the "Return" button
  Then I should be on the calendar page
