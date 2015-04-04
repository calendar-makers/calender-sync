Feature: pull 3rd-party events created on Meetup by event ID and display them on the calendar

  As an admin
  So that I can support other 3rd-party organizations with similar interests to my own
  I want to be able to collect their Meetup events and display them on my calendar

  Background: 3rd-party Events have already been created on Meetup

    And the following events exist on Meetup:
      |                 name       |    organization          |   event_id   |
      | Walk the Moon              | Live Music San Francisco | 220680184    |

    And I am on the calendar page
    And I click on the "third_party" link
    Then I should be on the "third_party" page
    And I should see the following fields: "ID"
    And I should see the "Search, Add Events" buttons

  Scenario: search an event
    Given I fill in the "ID" field with "220680184"
    And I click on the "Search" button
    Then I should be on the "third_party" page
    And I should see the list "#matched_events" containing: "Walk the Moon"

  Scenario: successfully pull an event
    Given I searched an event by id: "220680184"
    And I check "Select" for "event220680184"
    And I click on the "Add Events" button
    Then I should be on the "Calendar" page
    And I should see the message "Successfully added: Walk the Moon"

  Scenario: fail to pull an event
    Given I searched an event by id: "220680184"
    And I check "Select" for "event220680184"
    And I attempt to click on the "Add Events" button
    Then I should be on the "Calendar" page
    And I should see the message "Could not add event. Please retry."

  Scenario: attempt to pull no selected events
    Given I searched an event by id: "220680184"
    And I attempt to click on the "Add Events" button
    Then I should be on the "third_party" page
    And I should see the message "You must select at least one event. Please retry."








