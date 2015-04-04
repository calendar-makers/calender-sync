Feature: automatically pull existing events from Meetup onto the calendar

  As an admin of the website
  So that I can view all of Nature in the City's events in one place
  I want to be able to see website events and Meetup events on the same calendar


  Background: I have been authenticated, and Meetup and the website currently have disjoint sets of events

    Given I have logged in as an admin on Meetup
    And the following events exist on the calendar:
      |                 name                    |    organization    |   event_id   |

    And the following events exist on Meetup:
      |                 name                    |    organization    |   event_id   |
      | Nerds on Safari: Market Street          | Nature in the city | 220706208    |
      | Market Street Prototyping Festival      | Nature in the city | 219648262    |
      | Volunteer at the Adah Bakalinsky Steps! | Nature in the city | 214161012    |


  Scenario: perform a successful pull from Meetup
    Given I am on the "Calendar" page
    Then I should see the "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" links
    And I should see the message "Successfully pulled events: Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps! from Meetup"

  Scenario: failed pull from Meetup
    Given I am on the "Calendar" page
<<<<<<< HEAD
    #///////////  WHEN CALENDAR WORKS REMOVE NEXT LINE
    And I am on the "Events Directory" page
    Then I should see the "Nature Walk, Fried Tomatoes" links
    And I should not see the "Nature Stroll, Green Bean Mixer, New Nature, Gardening" links
    And I should see the message "Could not pull events from Meetup"
=======
    And I should not see the "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" links
    And I should see the message "Could not pull events from Meetup"
>>>>>>> a0660ac2106676a243726d02fa3e63287ffd494a
