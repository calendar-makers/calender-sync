@meetup_push
Feature: push new calendar events to meetup

    As an admin of the website
    To guarantee I don't have to maintain two sets of identical events
    I want to have events I create on the calendar automatically push to Meetup

  Background: create a new event
    Given I am logged in as the admin
    And I am an authorized organizer of the group
    And I am on the "Create" page
    And I fill in the "Event Name" field with "Nature Walk"
    And I fill in the "Venue Name" field with "Steps"
    And I fill in the "Address" field with "145 Jackson st"
    And I fill in the "City" field with "Glendale"
    And I fill in the "Zip" field with "90210"
    And I select "8/18/2015, 4:30pm" as the "start" date and time
    And I select "8/22/2015, 4:30pm" as the "end" date and time
    And I fill in the "Description" field with "Join us for a nature walk through old town Los Angeles!"
    And I fill in the "How to find us" field with "Turn right at Sunset and Vine"

  @successful_push
  Scenario: successfully push the newly created event to Meetup
      Given I click on the "Create Event" button
      Then I should be on the "Calendar" page
      And I should see the message "'Nature Walk' was successfully added and pushed to Meetup."
      And the "Nature Walk" event should exist on "both" platforms

  @failed_push
  Scenario: failed push of newly created event to Meetup (Implemented as a transaction)
      Given I click on the "Create Event" button
      Then I should be on the "Calendar" page
      And I should see the message "Failed to push event to Meetup. Creation aborted."
      And the "Nature Walk" event should exist on "neither" platforms


  # NOTE: The pull feature already handles the case in which an admin creates a new event on Meetup, and this event
  #       is then automatically pulled on the Calendar
