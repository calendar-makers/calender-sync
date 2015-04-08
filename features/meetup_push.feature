Feature: push new calendar events to meetup

    As an admin of the website
    To guarantee I don't have to maintain two sets of identical events
    I want to have events I create on the calendar automatically push to Meetup

  Background: create a new event
    Given I have logged in as an admin on Meetup
    And I am on the "Create" page
    And I fill in the "Event Name" field with "Nature Walk"
    And I fill in the "Description" field with "Join us for a nature walk through old town San Franciso!"
    And I select "3/19/2015, 4:30pm" as the date and time
    And I fill in the "Location" field with "The Old Town Hall"
    And I fill in the "Organization" field with "Nature in the City"

  Scenario: successfully push the newly created event to Meetup
      Given I click on the "Create Event" button
      Then I should be on the "Calendar" page
      And I should see the message "Event successfully pushed to Meetup"
      And the "Nature Walk" event should exist on both platforms

  Scenario: failed push of newly created event to Meetup (Implemented as a transaction)
      Given I click on the "Create Event" button
      Then I should be on the "Calendar" page
      And I should see the message "Failed to push event to Meetup. Creation aborted."
      And the "Nature Walk" event should exist on neither platforms


  # NOTE: The pull feature already handles the case in which an admin creates a new event on Meetup, and this event
  #       is then automatically pulled on the Calendar