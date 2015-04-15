@meetup_delete
Feature: Enforce event lists consistency by deleting events locally and remotely as required

  As an admin of the website
  To guarantee I don't have to maintain two sets of identical events
  I want to have automatic deletions between the Calendar events and the Meetup events

  Background: The Calendar and Meetup are currently synched
    Given I am an authorized organizer of the group
    And the following events exist on Meetup and on the Calendar
      |    name      |    organization    |   event_id   |
      | Nature Walk  | Nature in the city | 221850455    |

  @calendar_successful_deletion
  Scenario: deletion initiated on Calendar
    Given I am on the "details" page for "Nature Walk"
    And I click on the "Delete" button
    Then I should be on the "Calendar" page
    And the "Nature Walk" event should exist on "neither" platforms
    And I should see the message "'Nature Walk' was successfully removed."

  @calendar_failed_deletion
  Scenario: failed deletion initiated on Calendar
    Given I am on the "details" page for "Nature Walk"
    And I click on the "Delete" button
    Then I should be on the "Calendar" page
    And the "Nature Walk" event should exist on "both" platforms
    And I should see the message "Could not remove 'Nature Walk'"

  @meetup_successful_deletion
  Scenario: deletion initiated on Meetup
    Given the event "Nature Walk" is deleted on Meetup
    And I am on the "Calendar" page  # THIS REQUIRES YOU DO AUTOMATIC DELETION ON show in CALENDAR
    And the "Nature Walk" event should exist on "neither" platforms
    And I should see the message "The Calendar and Meetup are synched"
