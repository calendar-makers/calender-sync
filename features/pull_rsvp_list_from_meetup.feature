Feature: automatically pull existing RSVP list from Meetup onto the calendar

  As an admin of the website
  So that I can view the RSVP of an event in one place
  I want to see a merged RSVP list on my website

# Most of this is automated and behind the scene. All the user/admin will see is the calendar getting populated with meetup events.
# Application will check meetup for updates every time the calendar is accessed
# We'll probably be using a dummy Meetup organization for testing synchroinzation


# Again, RSVP merging is automated. All user/admin will see is the populated list
# Again, we'll be using a dummy organization with a dummy event
  Scenario: admin sees RSVP list for "Dummy" event
    Given I am on the "RSVP" page
    Then I should see "Aaron B. Chen"
    And I should see "abc@d.com"