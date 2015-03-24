Feature: automatically pull existing events from Meetup onto the calendar

  As an admin of the website
  So that I can view all of Nature in the City's events in one place
  I want to be able to see website events and Meetup events on the same calendar


  Background: I have been authenticated, and Meetup and the website currently have disjoint sets of events

    # CHECK THIS LOGIN BUSINESS... SHOULD WE DO EITHER OR BOTH?
    #Given I have logged in as an admin on the app
    Given I have logged in as an admin on Meetup
    And the following events exist on the calendar:
      | name             | organization       | description                               | start               | location                   |
      | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
      | Green Bean Mixer | Green Carrot       | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

    And the following events exist on Meetup:
      | name             | organization       | description                               | start               | location                   |
      | Nature Stroll    | Nature Matters     | An exciting journey                       | March 19 2015 16:30 | The old Town Hall          |
      | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |
      | New Nature       | Greens Are Us      | Greens for everyone                       | March 27 2015 20:30 | Berkeley                   |
      | Gardening        | Modern Gardeners   | Gardening 101                             | March 29 2015 20:30 | Berkeley                   |
      #YOU SHOULD PROBABLY USE CURL TO CAPTURE AN OUTPUT... BUT THEN SHOULD WE USE FACTORIES???

    Given I am on the "Events Directory" page
    Then I should see the list of events containing "Nature Walk, Green Bean Mixer"

  Scenario: perform a successful pull from Meetup
    Given I click on the "Calendar" button
    #Then I should be on the calendar page ///////////  WHEN CALENDAR WORKS USE THIS INSTEAD OF Events Directory
    Then I should be on the "Events Directory" page
    And I should see the "Nature Walk, Green Bean Mixer, Nature Stroll, Green Bean Mixer, New Nature, Gardening" links
    And I should see the message "Successfully pulled events: "Nature Stroll, Green Bean Mixer, New Nature, Gardening" from Meetup

  Scenario: failed pull from Meetup
    Given I click on the "Calendar" button
    #Then I should be on the calendar page ///////////  WHEN CALENDAR WORKS USE THIS INSTEAD OF Events Directory
    Then I should be on the "Events Directory" page
    And I should see the "Nature Walk, Green Bean Mixer" links
    And I should not see the "Nature Stroll, Green Bean Mixer, New Nature, Gardening" links
    And I should see the message "Could not pull events from Meetup"


