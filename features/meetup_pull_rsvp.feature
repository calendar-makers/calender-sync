Feature: automatically pull rsvp list from Meetup and merge to rsvp list in the calendar

  As an admin of the website
  So that I can view the RSVP of an event in one place
  I want to see a merged RSVP list on my website

  Background: A 3rd party event exists and it is successfully pulled to the calendar. Both sides have their respective RSVPs

    # SHOULD WE LOGIN TO EITHER OR BOTH?
    #Given I have logged in as an admin on the app
    Given I have logged in as an admin on Meetup
    # NEED TO GET A REALISTIC USER ID
    And the following events exist on Meetup:
      |id     | name             | organization       | description                | start               | location            |
      |123456 | Gardening        | Nature in the City | Cultivating some things    | March 19 2015 16:30 | The old Town Hall   |
    And the "meetup" event with id "123456" has the following RSVP list:
      | name              | email              |
      | Ben Franklin      | b.f@gmail.com      |
      | George Obama      | g.o@gmail.com      |
      | Chester Copperpot | c.c@gmail.com      |
      | Pepper Pot        | p.p@gmail.com      |
    ####  CONSIDERING USING NAMES INSTEAD OF IDs FOR THE CALENDAR... FOR THE MOMENT AT LEAST.
    And I pull the meetup event with id: "123456"
    And the "calendar" event with id "123456" has the following RSVP list:
      | name              | email              |
      | Antonio Banderas  | a.b@gmail.com      |
      | Bruce Willis      | b.w@gmail.com      |

  Scenario: successfully pull the RSVP for an event
     ###  AGAIN CONSIDER USING NAMES INSTEAD OF IDs
    Given I go to the "details" page for event id: "123456"
    Then I should see the following RSVP list:
      | name              | email              |
      | Ben Franklin      | b.f@gmail.com      |
      | George Obama      | g.o@gmail.com      |
      | Chester Copperpot | c.c@gmail.com      |
      | Pepper Pot        | p.p@gmail.com      |
      | Antonio Banderas  | a.b@gmail.com      |
      | Bruce Willis      | b.w@gmail.com      |

    And I should see the message "The RSVP list for this event has been updated: Ben Franklin, George Obama, Chester Copperpot, Pepper Pot, Antonio Banderas, Bruce Willis have joined"

  Scenario: fail to pull the RSVP for an event
     ###  AGAIN CONSIDER USING NAMES INSTEAD OF IDs
    Given I go to the "details" page for event id: "123456"
    Then I should see the following RSVP list:
      | name              | email              |
      | Ben Franklin      | b.f@gmail.com      |
      | George Obama      | g.o@gmail.com      |
      | Chester Copperpot | c.c@gmail.com      |
      | Pepper Pot        | p.p@gmail.com      |
    And I should not see the following RSVP list:
      | name              | email              |
      | Ben Franklin      | b.f@gmail.com      |
      | George Obama      | g.o@gmail.com      |
      | Chester Copperpot | c.c@gmail.com      |
      | Pepper Pot        | p.p@gmail.com      |
      | Antonio Banderas  | a.b@gmail.com      |
      | Bruce Willis      | b.w@gmail.com      |

    And I should see the message "Could not merge RSVP lists for this event"




