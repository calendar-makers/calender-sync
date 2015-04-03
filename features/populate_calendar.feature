Feature: Populate calendar with events

  As an admin
<<<<<<< HEAD
  So that I can advertise my events to website visitors
=======
  So that I can advertise my events to website vistors
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
  I want to be able to populate my calendar with events

Background: Events have already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

Scenario: see calendar options
  Given I am on the "Calendar" page
  Then I should see "Nature Walk" as the "Event name"
  Then I should see "Green Bean Mixer" as the "Event name"
  And I should see filter/search options
  And I should see calendar navigation tools

Scenario: see events on the calendar page
  Given I am on the calendar page
  Then I should see "Nature Walk" on "April 4"
  When I click the event "Nature Walk"
<<<<<<< HEAD
  Then I should be on the "details" page for "Nature Walk"
=======
  Then I should be on the details page for "Nature Walk"
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
