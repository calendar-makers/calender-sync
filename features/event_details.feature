Feature: View event details on the admin page.
	As an admin user
	So that I see all of the details of an event
	I want to see each event's details displayed below it in the event list on the admin panel

Background: Events have already been added to the database

  Given the following events exist:
    | name  | datetime_start      | datetime_end      | location          | description | status    |
    | Hike1 | 12/21/2016 9:00 am  | 12/21/16 12:00 pm | 1210 street rd SF | A hike      | approved  |
    | Hike2 | 12/25/2016 9:00 am  | 12/25/16 12:00 pm | 1210 street rd SF | A hike      | pending   |
    | Hike3 | 12/27/2016 9:00 am  | 12/27/16 12:00 pm | 1210 street rd SF | A hike      | rejected  |
    | Hike4 | 12/30/2016 9:00 am  | 12/30/16 12:00 pm | 1210 street rd SF | A hike      | approved  |
    
    And I am on the admin page
    And the date is "12/22/2016"

Scenario: Display upcoming event details
  Given I am displaying the "Upcoming" events
  Then  I should see "Hike4"
  And   I should see the following details displayed below "Hike4":  "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events: "Hike1", "Hike2", "Hike3"
  
Scenario: Display pending event details
  Given I am displaying the "Pending" events
  Then  I should see "Hike2"
  And   I should see the following details displayed below "Hike2": "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events:"Hike1", "Hike3", "Hike4"

Scenario: Display rejected event details
  Given I am displaying the "Rejected" events
  Then  I should see "Hike3"
  And   I should see the following details displayed below "Hike3": "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events:"Hike1", "Hike2", "Hike4"

Scenario: Display past event details
  Given I am displaying the "Past" events
  Then  I should see "Hike1"
  And   I should see the following details displayed below "Hike1": "Name", "Start Time", "End Time", "Location", "Description", "Status"
  But   I should not see the following events:"Hike2", "Hike3", "Hike4"
