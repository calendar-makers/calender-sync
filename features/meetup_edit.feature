Feature: Enforce event lists consistency by updating events locally and remotely as required

  As an admin of the website
  To guarantee I don't have to maintain two sets of identical events
  I want to have automatic updates between the Calendar events and the Meetup events

  Background: The Calendar and Meetup are currently synched

    Given I am an authorized organizer of the group
    And the following events exist on Meetup and on the Calendar
      |                 name                    |    organization    |   event_id   |
      | Market Street Prototyping Festival      | Nature in the city | 219648262    |
      | Nerds on Safari: Market Street          | Nature in the city | 220706208    |
      | Volunteer at the Adah Bakalinsky Steps! | Nature in the city | 214161012    |


  Scenario: update initiated on Calendar
    Given I am on the "details" page for "Market Street Prototyping Festival"
    And I click on the "Edit" button
    And I should be on the "Edit" page for "Market Street Prototyping Festival"
    And I fill in the "Event Name" field with "Festival"
    And I click on the "Update Event Info" button
    Then the event "Market Street Prototyping Festival" should be renamed to "Festival" on "both" platforms
    And I should see the message "Market Street Prototyping Festival was successfully updated."

  Scenario: failed update initiated on Calendar
    Given I am on the "details" page for "Market Street Prototyping Festival"
    And I click on the "Edit" button
    And I should be on the "Edit" page for "Market Street Prototyping Festival"
    And I fill in the "Event Name" field with "Festival"
    And I click on the "Update Event Info" button
    Then the event "Market Street Prototyping Festival" should be renamed to "Festival" on "neither" platforms
    And I should see the message "Could not update Market Street Prototyping Festival."

  Scenario: update initiated on Meetup
    Given the event "Market Street Prototyping Festival" is renamed on Meetup to "Festival"
    And I am on the "Calendar" page
    Then the event "Market Street Prototyping Festival" should be renamed to "Festival" on "both" platforms
    And I should see the message "Successfully pulled events: Festival from Meetup."
