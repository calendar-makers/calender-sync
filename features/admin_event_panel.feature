
Feature: View events by status on the admin page.
	As an admin user
	So that I can easily switch between events of different status groups
	I want to see the events categorized under past, upcoming, pending, and rejected tabs

Background: Events have already been added to the database
  Given the following events exist:
    | name  | start               | end               | st_number | st_name   | city  | description | status    |
    | Hike  | 12/21/2016 9:00 am  | 12/21/16 12:00 pm | 1210      | street rd | SF    | A hike      | approved  |
    | Hike4 | 12/30/2016 9:00 am  | 12/30/16 12:00 pm | 1210      | street rd | SF    | A hike      | approved  |
    | Hike2 | 12/25/2016 9:00 am  | 12/25/16 12:00 pm | 1210      | street rd | SF    | A hike      | pending   |
    | Hike3 | 12/27/2016 9:00 am  | 12/27/16 12:00 pm | 1210      | street rd | SF    | A hike      | rejected  |
    And I am on the admin page
    And I see the "Admin" panel
    And I see the following status tabs: Upcoming, Pending, Rejected, Past
    And the date is "12/25/2016"

Scenario: show upcoming events
  Given I see the "Upcoming" status tab 
  And   I press the "Upcoming" tab
  Then  I should see approved events with dates after "12:00am" today
  And   I should see the events sorted by date in ascending order
  And   I should not see approved events with date before "12:00am" today

Scenario: show past events
  Given I see the "Past" status tab
  When  I press the "Past" tab
  Then  I should see approved events with dates before "12:00am" today
  And   I should see the events sorted by date in descending order
  And   I should not see approved events with date after "12:00am" today

Scenario: show pending events
  When  I press the "Pending" status tab
  Then  I should see pending events
  And   I should see the events sorted by date in ascending order
  And I should not see "Approved" or "Rejected" or "Past" events
  
Scenario: show rejected events
  When  I press the "Rejected" status tab
  Then  I should see rejected events
  And   I should see the events sorted by date in ascending order
  And   I should not see "Approved" or "Upcoming" or "Past" events 