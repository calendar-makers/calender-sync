Feature: Set up O-Auth2 so admin can login to Meetup

    As an admin of the website
    So that I can interact with Meetup
    I want to be able to login to Meetup from the website

Scenario: admin attempts to login
    Given I am on the "Calendar" page
    And I have not already logged in
    When I click on the "login" link
    Then I should be on the "Meetup Login" page

#Scenario: admin attempts to create event while not logged in
#    Given I create an event and submit it
#    And I have not already logged in

Scenario: admin attempts to login
    Given I am on the "Meetup Login" page
    And I fill in the "Login" field with "admin"
    And I fill in the "Password" field with "password"
    And I click on the "Submit" button
    Then I should be on the "Events Directory" page
    And I should see "Succesfully logged in"

Scenario: admin attempts to login unsuccessfully
    Given I am on the "Meetup Login" page
    And I click on the "Submit" button
    Then I should be on the "Meetup Login" page
    And I should see "Unsuccessful login!"

Scenario: admin attempts to logout
    Given I am on the "Events Directory" page
    And I have already logged in as an admin on Meetup
    When I click on the "signout" button
    Then I should see "Succesfully logged out"
    And I should be on the "Events Directory" page
