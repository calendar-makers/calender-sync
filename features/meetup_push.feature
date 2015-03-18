Feature: as an admin, create events on the website and push to meetup

    As an admin of the website
    So I don't have to create events redundantly
    I want to have events I create on the website automatically push to Meetup

Scenario: admin attempts to create event while logged in
    Given I am on the "Create" page
    And I am already logged into Meetup
    And I fill in the "Event Name" field with "Nature Walk"
    And I fill in the "Description" field with "Join us for a nature walk through old town San Franciso!"
    And I select "3/19/2015, 4:30pm" as the date and time
    And I fill in the "Location" field with "The Old Town Hall"
    And I fill in the "Organization" field with "trololol"
    And I click on the "Create Event" button
    Then I should be on the "Events Directory" page
    And I should see "Event successfully pushed to Meetup"
