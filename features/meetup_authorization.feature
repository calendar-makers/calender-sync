Feature: Set up O-Auth2 so admin can login to Meetup

    As an admin of the website
    So that I can interact with Meetup
    I want to be able to login to Meetup from the website

@omniauth_test
Scenario: admin attempts to login
    Given I have not already logged in to Meetup
    When I click on the "login to Meetup" link
    Then I should be on the "Calendar" page
    And I should see "Signed in!"
# ERROR: if app is approved by Meetup user, will auto redirect
# how do I emulate this behavior?

@omniauth_test
Scenario: admin attempts to logout
    Given I have already logged in to Meetup
    When I click on the "Sign Out" link
    Then I should see "Signed out!"
    And I should be on the "Calendar" page
