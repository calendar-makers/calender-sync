Feature: Populate calendar with events

  As an admin
  So that I can advertise my events to website vistors
  I want to be able to populate my calendar with events

Background: events have been added to database
  event       | date         | start_time
  Nature Walk | April-4-2015 | 9:00

Scenario: see calendar options
  When I click on the calendar page
  Then I should see events in the calendar
  And I should see filter/search options
  And I should see calendar navigation tools

Scenario: see events on the calendar page
  Given I am on the calendar page
  Then I should see "Nature Walk" on "April 4"
