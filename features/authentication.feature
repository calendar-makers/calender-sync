Feature: authentication for our application

  As an admin,
  So that I can access actions that alter the behavior of the calendar,
  I want to be able to login to the application

Scenario: Guests should not see admin actions
  Given I am not logged in as the admin
  And   I am on the "Calendar" page
  Then  I should not see the admin actions

# Design decision, access "Login" page via URL, not button on calendar
Scenario: Admins should be able to login with proper credentials
  Given I am not logged in as the admin
  And   I am on the "Login" page
  When  I fill in the login information
  Then  I should be on the "Calendar" page
  And   I should see "Logged in"

Scenario: Admins should be able to logout
  Given I am logged in as the admin
  And   I am on the "Calendar" page
  When  I click on the "Log out" button
  Then  I should be on the "Calendar" page
  And   I should see "Logged out"

Scenario: Admins should see admin actions
  Given I am logged in as the admin
  And   I am on the "Calendar" page
  Then  I should see the admin actions
