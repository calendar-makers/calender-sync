Feature: pull 3rd-party events created on Meetup by event ID and display them on the calendar

  As an admin
  So that I can support other 3rd-party organizations with similar interests to my own
  I want to be able to collect their Meetup events and display them on my calendar

  Background: 3rd-party Events have already been created on Meetup and I have been authenticated

    # SHOULD WE LOGIN TO EITHER OR BOTH?
    #Given I have logged in as an admin on the app
    Given I have logged in as an admin on Meetup
    # NEED TO GET A REALISTIC USER ID
    And the following events exist on Meetup:
      |id     | name             | organization       | description                | start               | location            |
      |123456 | Gardening        | Nature in the City | Cultivating some things    | March 19 2015 16:30 | The old Town Hall   |
    And I am on the calendar page
    And I click on the "pull 3rd-party event by id" button
    Then I should be on the "import 3rd-party event by id" page
    And I should see the "add new organizations" button
    And I should see the following fields: "Event ID"
    And I should see the "Import, Cancel" buttons

  Scenario: successfully pull an event
    Given I fill in the "Event ID" field with "123456"
    And I click on the "Import Selected Events" button
    Then I should be on the "Calendar" page
    And I should see the "Gardening" link
    And I should see the message "Successfully pulled events: 'Gardening' from Meetup"

  Scenario: fail to pull an event
    Given I fill in the "Event ID" field with "123456"
    And I click on the "Import Selected Events" button
    Then I should be on the "Calendar" page
    And I should see the message "Could not pull events from Meetup"
    And I should not see the "Gardening" link
    # Later redirect to the actual calendar

  Scenario: cancel operation
    Given I click on the "Cancel" button
    Then I should be on the "Calendar" page
    And I should not see the "Gardening" link






