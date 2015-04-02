Feature: automatically pull existing events from Meetup onto the calendar
    As a visitor of the website
    So that I can view all of Nature in the City's events in one place
    I want to be able to see website events and Meetup events on the same calendar

    As an admin of the website
    So that I can display 3rd party events relevant to my organization
    I want to be able to 3rd party meetup events on my calendar

    As an admin of the website
    So that I can view the RSVP of an event in one place
    I want to see a merged RSVP list on my website

# Most of this is automated and behind the scene. All the user/admin will see is the calendar getting populated with meetup events.
# Application will check meetup for updates every time the calendar is accessed
# We'll probably be using a dummy Meetup organization for testing synchroinzation
Scenario: user sees existing meetup events on the calendar (non-3rd party)
    Given I am on the "Calendar" page
    Then I should see "Meetup Event"

Scenario: admin displays 3rd party organizations' events
    Given I am on the "Events Directory" page
    And I am logged into Meetup
    When I fill out the "Meetup Organization" field with "Organization Name"
    And I click "Submit"
    Then I should be on the "Events Directory" page
    Then I should see "Organization event"

# Again, RSVP merging is automated. All user/admin will see is the populated list
# Again, we'll be using a dummy organization with a dummy event
Scenario: admin sees RSVP list for "Dummy" event
    Given I am on the "RSVP" page
    Then I should see "Aaron B. Chen"
    And I should see "abc@d.com"
