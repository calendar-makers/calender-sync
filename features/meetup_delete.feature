Feature: Enforce event lists consistency by deleting events locally and remotely as required

  As an admin of the website
  To guarantee I don't have to maintain two sets of identical events
  I want to have automatic deletions between the Calendar events and the Meetup events

  Background: The Calendar and Meetup are currently synched

    Given I am an authorized organizer of the group
    And the following events exist on Meetup and on the Calendar
      |                 name                    |    organization    |   event_id   |
      | Market Street Prototyping Festival      | Nature in the city | 219648262    |
      | Nerds on Safari: Market Street          | Nature in the city | 220706208    |
      | Volunteer at the Adah Bakalinsky Steps! | Nature in the city | 214161012    |


  Scenario: deletion initiated on Calendar
    Given I am on the "details" page for "Market Street Prototyping Festival"
    And I click on the "Delete" button
    Then I should be on the "Calendar" page
    And the "Market Street Prototyping Festival" should exist on "neither" platform
    And I should see the message "Market Street Prototyping Festival was successfully removed."

  Scenario: failed deletion initiated on Calendar
    Given I am on the "details" page for "Market Street Prototyping Festival"
    And I click on the "Delete" button
    Then I should be on the "Calendar" page
    And the "Market Street Prototyping Festival" should exist on "both" platform
    And I should see the message "Could not remove Market Street Prototyping Festival"

  Scenario: deletion initiated on Meetup
    Given the event "Market Street Prototyping Festival" is deleted on Meetup
    And I am on the "Calendar" page
    And the "Market Street Prototyping Festival" should exist on "neither" platform
    And I should see the message "The Calendar and Meetup are synched"
