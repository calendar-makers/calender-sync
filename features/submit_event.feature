Feature: Guests can submit Events for approval by an admin
  
  As a guest of Nature in the City
  So that I can bring the Nature in the City community to my Event
  I want to submit my Event to the calendar for approval by an admin 
  
Given I am on the Calendar page
And I click "Submit Event"
Then I should see "Submit your Event"
  
Scenario: Submit an Event 
  When I fill in required Event details
  And I click "Submit"
  Then I should see "Your Event was successfully submitted for approval!"
  
Scenario: Submit Event failure
  When I fill in "Event Name" with "Test Name"
  And I click "Submit"
  Then I should see "You must fill out all required fields (marked with a *)"