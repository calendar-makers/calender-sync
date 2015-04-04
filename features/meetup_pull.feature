Feature: automatically pull existing events from Meetup onto the calendar

  As a user of the website
  So that I can view all of Nature in the City's events in one place
  I want to be able to see website events and Meetup events on the same calendar


  Background: I have been authenticated, and Meetup and the website currently have disjoint sets of events

    Given the following events exist on the calendar:
      |                 name                    |    organization    |   event_id   |

    And the following events exist on Meetup:
      |                 name                    |    organization    |   event_id   |
      | Market Street Prototyping Festival      | Nature in the city | 219648262    |
      | Nerds on Safari: Market Street          | Nature in the city | 220706208    |
      | Volunteer at the Adah Bakalinsky Steps! | Nature in the city | 214161012    |


  Scenario: perform a successful pull from Meetup
    Given I am on the "Calendar" page
    Then the Meetup events "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" should exist
    And I should see the message "Successfully pulled events: Market Street Prototyping Festival, Nerds on Safari: Market Street, Volunteer at the Adah Bakalinsky Steps! from Meetup"

  Scenario: failed pull from Meetup
    Given I attempt to go to the "Calendar" page
    Then the Meetup events "Nerds on Safari: Market Street, Market Street Prototyping Festival, Volunteer at the Adah Bakalinsky Steps!" should not exist
    And I should see the message "Could not pull events from Meetup"