Feature: update information of an event

  As an admin
  So that I can change the details of events I've already created
  I want to be able to update events

Background: Event has already been added to the database

  Given the following events exist:
  | organization       | event_name       | details                                   | date       | time  | location
  | Nature in the City | Nature Walk      | A walk through the city                   | 19:03:2015 | 16:30 | The old Town Hall
  | Green Carrots      | Green Bean Mixer | If you like beans you'll like this event! | 12:03:2015 | 00:00 | San Francisco City Library

  And I am on the "details" page for "Nature in the City"'s "Nature Walk

Scenario: navigate to edit page and see all of the information
  When I click on the "Edit Event" button
  Then I should be on the "details" page
  When I click on the "Edit Event" button 
  Then I should be on the "edit" page 
  Then I should be on the "Create" page
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Add Event Details" field should be populated with "A walk through the city"
  And the "Date" field should be populated with "3/19/2015"
  And the "Location" field should be populated with "The Old Town Hall"
  And the "Time" field should be poplulated with "4:30"
  
Scenario: correctly change information results in change
  Given I am on the "edit" page for "Nature in the City"'s "Nature Walk"
  And I replace the "Location" text with "The New Town Hall"
  And I click the "Update Event Information" button
  Then I should be on the "details" page
  And I should see "Location: The New Town Hall"
  And I should not see "Location: The Old Town Hall"
  
Scenario: make sure user correctly changes information in edit page
  Given I am on the "edit" page for "Nature in the City"'s "Nature Walk"
  And I replace the "Location" text with " "
  And I click the "Update Event Information" button
  Then I should be on the "edit" page
  And I should see the flash message "Please complete the edit page form"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Add Event Details" field should be populated with "A walk through the city"
  And the "Date" field should be populated with "3/19/2015"
  And the "Location" field should be populated with " "
  And the "Time" field should be populated with "4:30"
