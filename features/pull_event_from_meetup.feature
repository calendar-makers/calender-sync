Feature: pull events created on Meetup and display them on the calendar

  As an admin
  So that I can collect all my previously created Meetup events on my calendar
  I want to be able to pull my own events from Meetup and display them on my calendar

  Background: Events have already been created on Meetup and I have been authenticated

    Given I have logged in as an admin on the app
    And I have logged in as an admin on Meetup
    And the following events exist on Meetup:
      | name             | organization       | description                               | start               | location                   |
      | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
      | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

    And I am on the calendar page
    And I click on the "pull my events" button
    Then I should be on the "import events" page
    And I should see the following fields: "Accept, Organization Name, Event Name, Description, Start Time, Location"
    And I should see the "Import, Cancel" buttons
    And I should see the list of events containing "Nature Walk, Green Bean Mixer"
    And I should see the fields: "Organization Name, Event Name, Description, Start Time, Location" for "Nature Walk", "Green Bean Mixer"
    And I should see "check" the check-box "Accept" for "Nature Walk, Green Bean Mixer"

  Scenario: accept all events
    Given I click on the "Import" button
    Then I should be on the "Events Directory" page
    And I should see the "Nature Walk", "Green Bean Mixer" links
    # Later redirect to the actual calendar

  Scenario: accept no events
    Given I "uncheck" the check-box "Accept" for "Nature Walk, Green Bean Mixer"
    And I click on the "Import" button
    Then I should see the warning "No events were accepted. Nothing to import."
    And I click on the "Cancel" button
    And I should be on the "Events Directory" page
    And I should not see the "Nature Walk, Green Bean Mixer" links

  Scenario: cancel operation
    Given I click on the "Cancel" button
    Then I should be on the "Events Directory" page
    And I should not see the "Nature Walk, Green Bean Mixer" links






