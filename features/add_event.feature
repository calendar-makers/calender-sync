Feature: Admins can directly add events to the calendar
  
  As a admin of Nature in the City
  So that I tell the NITC community about an event
  I want to add an Event to the Calendar through the NITC website
  
Given I am on the Admin Calendar page
And I click "Add Event"
Then I should see "Add New Event"
  
Scenario: Add an Event 
  When I fill in required Event details for an event "Test Event" in "March"
  And I click "Submit"
  Then I should see "Event Successfully Added!"
  When I go to the Calendar page
  And I go to month "March"
  Then I should see "Test Event"
  
  
Scenario: Submit Event failure
  When I fill in "Event Name" with "Test Name"
  And I click "Submit"
  Then I should see "You must fill out all required fields (marked with a *)"