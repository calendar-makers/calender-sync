Feature: create an event and have it displayed on the calendar

  As an admin
  so that I can add events to my calendar
	I want to be able to create events

Background: I have logged in as an admin and have permission to create

Scenario: redirect to create page when create new event button pushed
	Given I am on the "Calendar" page
	And I click the "Create New Event" button
	Then I should be on the "Create" page
	And I should see the following fields: Event Name, Add Event Details, Date, Location, Time
	And I should see the "Submit" button
	And I should see the "Organization Name" on the page

Scenario: store information when all the fields are filled out
	Given I am on the "Create" page
	And I fill in the "Event Name" field with "Nature Walk"
	And I fill in the "Add Event Details" field with "Join us for a nature walk through old town San Francicso!"
	And I fill in the "Date" field with "3/19/2015"
	And I fill in the "Location" field with "The Old Town Hall"
	And I fill in the "Time" field with "4:30 PM"
	And I click the "Submit" button
	Then I should be on the "Calendar" page
	And I should see "Nature Walk" link on "3/19/2015"
	
Scenario: make sure that that all event fields are filled in
  Given I am on the "Create" page
  And I fill in the "Event Name" field with "Nature Walk"
	And I fill in the "Add Event Details" field with "Join us for a nature walk through old town San Francicso!"
	And I fill in the "Date" field with "3/19/2015"
	And I fill in the "Location" field with "The Old Town Hall"
	And I click the "Submit" button
	Then I should be on the "Create" page
	And I should see the flash message "Please complete the event page form"
	And the "Event Name" field should be populated with "Nature Walk"
	And the "Add Event Details" field should be populated with "Join us for a nature walk through old town San Francicso!"
	And the "Date" field should be populated with "3/19/2015"
	And the "Location" field should be populated with "The Old Town Hall"
	And the "Time" field should not be populated
	
  
