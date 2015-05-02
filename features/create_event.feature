# Deprecated feature, we should be creating events in the panel
Feature: create an event and have it displayed on the calendar

  As an admin
  so that I can add events to my calendar
  I want to be able to create events

Scenario: redirect to create page when create new event button pushed
  Given I am on the calendar page
  And I am logged in as the admin
  And I click on the "Create new event" link
  Then I should be on the "Create" page
  And I should see the following fields: "Organization Name, Event Name, Venue Name, Address, City, Zip, State, Country, Description, Start Time, End Time, How to find us"
  And I should see the "Create Event" button

Scenario: Require all fields to be filled during event creation
  Given I am logged in as the admin
  And I am on the "Create" page
  And I click on the "Create Event" button
  Then I should be on the "Create" page
  And I should see "Please fill in the following fields" on the page

Scenario: store information when all the fields are filled out
  Given I am logged in as the admin
  And I am on the "Create" page
  And I fill in the "Event Name" field with "Nature Walk"
  And I fill in the "Venue Name" field with "Steps"
  And I fill in the "event_st_number" field with "145"
  And I fill in the "event_st_name" field with "Jackson st"
  And I fill in the "City" field with "Glendale"
  And I fill in the "Zip" field with "90210"
  And I select "8/18/2015, 4:30pm" as the "start" date and time
  And I select "8/22/2015, 4:30pm" as the "end" date and time
  And I fill in the "Description" field with "Join us for a nature walk through old town Los Angeles!"
  And I fill in the "How to find us" field with "Turn right at Sunset and Vine"
  And I click on the "Create Event" button
  Then I should be on the "Calendar" page
  #Then I should see the "Nature Walk" link
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
