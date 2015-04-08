@javascript
Feature: populate the event panel with event details
  As a user
  to learn the details of events I might want to go to
  I want to see event details in the panel

Background: events have already been added to the database
  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | April 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | April 12 2015 00:00 | San Francisco City Library |
  Given I am on the calendar page

Scenario: see the event "what"
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display "Green Bean Mixer" in its "What" field

Scenario: see the event "when"
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display "Apr 19, 2015 at 4:30 pm to Apr 19, 2015 at 6:30 pm" in its "When" field

Scenario: see the event "where"
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display "The old Town Hall" in its "Where" field

Scenario: see all event details in panel, including image and description
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display its details
  And when I click "Nature Walk" in the calendar
  Then the panel should display its details
