Feature: create an event and have it displayed on the calendar

  As an admin
  so that I can add events to my calendar
  I want to be able to create events

Background: I have logged in as an admin and have permission to create

Scenario: redirect to create page when create new event button pushed
  Given I am on the calendar page
  And I click on the "new event" link
  Then I should be on the "Create" page
  And I should see the following fields: "Organization Name, Event Name, Description, Start Time, Location"
  And I should see the "Create Event" button

Scenario: Require all fields to be filled during event creation
  Given I am on the "Create" page
  And I click on the "Create Event" button
  Then I should be on the "Create" page
  And I should see "Please fill in the following fields" on the page

Scenario: store information when all the fields are filled out
  Given I am on the "Create" page
  And I fill in the "Event Name" field with "Nature Walk"
  And I fill in the "Description" field with "Join us for a nature walk through old town San Franciso!"
  And I select "3/19/2015, 4:30pm" as the date and time
  And I fill in the "Location" field with "The Old Town Hall"
  And I fill in the "Organization" field with "trololol"
  And I click on the "Create Event" button
  Then I should be on the "Events Directory" page
  Then I should see the "Nature Walk" link
  #And I should see "Nature Walk" link on "3/19/2015"
  #And I should see ""Nature Walk" was successfully added."

#unimplemented
#Scenario: make sure that that all event fields are filled in
#  Given I am on the "Create" page
#  And I fill in the "Event Name" field with "Nature Walk"
#  And I fill in the "Description" field with "Join us for a nature walk through old town San Francicso!"
#  And I select "3/19/2015" as the date
#  And I fill in the "Location" field with "The Old Town Hall"
#  And I click on the "Create Event" button
#  Then I should be on the "Create" page
#  And I should see the flash message "Please complete the event page form"
#  And the "Event Name" field should be populated with "Nature Walk"
#  And the "Add Event Details" field should be populated with "Join us for a nature walk through old town San Francicso!"
#  And the "Date" field should be populated with "3/19/2015"
#  And the "Location" field should be populated with "The Old Town Hall"
#  And the "Time" field should not be populated
