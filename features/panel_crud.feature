@javascript
Feature: Be able to create, edit, and delete events via a panel on the calendar page

  As an admin
  so that I can manage events all in one place
  I want to be able to create, edit, and delete events on the calendar page

Background: Events have already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

  And I am on the calendar page

Scenario: Show the new event panel to create events
  When I click on the "new event" link
  Then I should see the "Create Event" panel
  When I create an event called "Gardening" that starts at "April 10 08:00"
  Then I should see "Gardening" on "April 10" on the calendar

Scenario: Show the event editing panel
  When I choose to edit the event "Nature Walk"
  Then I should see the "Edit Event" panel
  When I change the start time of "Nature Walk" to "April 16 00:00"
  Then I should see "Nature Walk" on "April 16" on the calendar
  But I should not see "Nature Walk" on "March 19" on the calendar

Scenario: Delete an event
  When delete the event "Green Bean Mixer"
  Then "Green Bean Mixer" should not be on the calendar
