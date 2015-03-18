Feature: Set up O-Auth2 so admin can login to Meetup

    As an admin of the website
    So that I can interact with Meetup
    I want to be able to login to Meetup from the website

Background: None needed, I think

Scenario: admin attempts to login
    Given I am on the "Events Directory" page
    And I am not already logged into Meetup
    When I click on the "Meetup Login" button
    Then I should be on the "Meetup Login" page

Scenario: admin attempts to create event while not logged in
    Given I am on the "Create" page
    And I am not already logged into Meetup
    And I fill in the "Event Name" field with "Nature Walk"
    And I fill in the "Description" field with "Join us for a nature walk through old town San Franciso!"
    And I select "3/19/2015, 4:30pm" as the date and time
    And I fill in the "Location" field with "The Old Town Hall"
    And I fill in the "Organization" field with "trololol"
    And I click on the "Create Event" button
    Then I should be on the "Meetup Login" page

Scenario: admin attempts to login
    Given I am on the "Meetup Login" page
    And I fill in the "Login" field with "admin"
    And I fill in the "Password" field with "password"
    And I click the "Submit" button
    Then I should be on the "Events Directory" page
    And I should see "Succesfully logged in"

Scenario: admin attempts to login unsuccessfully
    Given I am on the "Meetup Login" page
    And I click the "Submit" button
    Then I should be on the "Meetup Login" page
    And I should see "Unsuccessful login!"

Scenario: admin attempts to logout
    Given I am on the "Events Directory" page
    And I am already logged into Meetup
    When I click on the "Meetup Logout" button
    Then I should see "Succesfully logged out"
    And I should be on the "Events Directory" page
