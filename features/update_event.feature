Feature: update information of an event

  As an admin
  So that I can change the details of events I've already created
  I want to be able to update events

Background: Event has already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | start                | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015, 16:30 | The Old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015, 00:00 | San Francisco City Library |

Scenario: navigate to edit page and see all of the information
  Given I am on the "details" page for "Nature Walk"
  When I click on the "Edit" link
  Then I should be on the "Edit" page for "Nature Walk"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Description" field should be populated with "A walk through the city"
  And the "start" time field should be populated with "3/19/2015, 4:30pm"
  And the "Location" field should be populated with "The Old Town Hall"

Scenario: correctly change information results in change
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Location" field with "The New Town Hall"
  And I click on the "Update Event Info" button
  Then I should be on the "Details" page for "Nature Walk"
  And I should see "The New Town Hall" as the "Location"

Scenario: make sure user correctly changes information in edit page
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Location" field with ""
  And I click on the "Update Event Info" button
  Then I should be on the "Edit" page for "Nature Walk"
<<<<<<< HEAD
  And I should see the message "Please fill in the following fields before submitting: location"
=======
  And I should see the flash message "Please complete the Edit page form"
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Description" field should be populated with "A walk through the city"
  And the "Start" time field should be populated with "3/19/2015, 4:30pm"
  And the "Location" field should be populated with "The Old Town Hall"
