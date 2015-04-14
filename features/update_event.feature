Feature: update information of an event

  As an admin
  So that I can change the details of events I've already created
  I want to be able to update events

Background: Event has already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | start                | venue_name                 |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015, 16:30 | The Old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015, 00:00 | San Francisco City Library |

Scenario: navigate to edit page and see all of the information
  Given I am on the "details" page for "Nature Walk"
  When I click on the "Edit" link
  Then I should be on the "Edit" page for "Nature Walk"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Description" field should be populated with "A walk through the city"
  And the "start" time field should be populated with "3/19/2015, 4:30pm"
  And the "Venue Name" field should be populated with "The Old Town Hall"

Scenario: correctly change information results in change
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Venue Name" field with "The New Town Hall"
  And I click on the "Update Event Info" button
  Then I should be on the "Calendar" page

Scenario: make sure user correctly changes information in edit page
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Venue Name" field with ""
  And I click on the "Update Event Info" button
  Then I should be on the "Edit" page for "Nature Walk"
  And I should see the message "Please fill in the following fields before submitting: location"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Description" field should be populated with "A walk through the city"
  And the "Start" time field should be populated with "3/19/2015, 4:30pm"
  And the "Venue Name" field should be populated with "The Old Town Hall"
