Feature: update information of an event

  As an admin
  So that I can change the details of events I've already created
  I want to be able to update events

Background: Event has already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | date          | time  | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 | 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 | 00:00 | San Francisco City Library |

  And I am on the details page for "Nature Walk"

Scenario: navigate to edit page and see all of the information
  When I click on the "Edit Event" button
  Then I should be on the "Edit" page
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Add Event Details" field should be populated with "A walk through the city"
  And the "Date" field should be populated with "3/19/2015"
  And the "Location" field should be populated with "The Old Town Hall"
  And the "Time" field should be populated with "4:30"
  And I should see ""Nature Walk" was successfully updated."

Scenario: correctly change information results in change
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Location" field with "The New Town Hall"
  And I click on the "Update Event Information" button
  Then I should be on the "details" page
  And I should see "Location: The New Town Hall"
  And I should not see "Location: The Old Town Hall"

Scenario: make sure user correctly changes information in edit page
  Given I am on the "Edit" page for "Nature in the City"'s "Nature Walk"
  And I fill in the "Location" field with " "
  And I click on the "Update Event Information" button
  Then I should be on the "Edit" page
  And I should see the flash message "Please complete the Edit page form"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Add Event Details" field should be populated with "A walk through the city"
  And the "Date" field should be populated with "3/19/2015"
  And the "Location" field should be populated with " "
  And the "Time" field should be populated with "4:30"
