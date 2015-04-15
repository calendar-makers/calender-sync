@javascript
Feature: populate the event panel with event details
  As a user
  to learn the details of events I might want to go to
  I want to see event details in the panel

Background: events have already been added to the database
  Given the following events exist:
  | name             | organization       | description             | start               | end                 | address_1         |
  | Nature Walk      | Nature in the City | A walk through the city | April 19 2015 16:30 | April 19 2015 18:30 | The forest        |
  | Green Bean Mixer | Green Carrots      | Come if you like beans! | April 12 2015 00:00 | April 13 2015 00:00 | The old Town Hall |
  Given I am on the calendar page

Scenario: see the event heading
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display "Green Bean Mixer" as the heading

Scenario: see the event "when"
  Given the month is April 2015
  When I click on "Nature Walk" in the calendar
  Then the panel should display "Apr 19th 2015, 4:30 pm to 6:30 pm" in its "When" field
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display "Apr 12th 2015, 12:00 am to Apr 13th 2015, 12:00 am" in its "When" field

Scenario: see the event "where"
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display "The old Town Hall" in its "Where" field

Scenario: see all event details in panel, including image and description
  Given the month is April 2015
  When I click on "Green Bean Mixer" in the calendar
  Then the panel should display the description for "Green Bean Mixer"
  And when I click "Nature Walk" in the calendar
  Then the panel should display the description for "Green Bean Mixer"
