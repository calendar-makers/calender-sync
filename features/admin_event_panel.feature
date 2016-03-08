
Feature: View events by status on the admin page.
	As an admin user
	So that I can easily switch between events of different status groups
	I want to see the events categorized under past, upcoming, pending, and rejected tabs

Background: Events have already been added to the database
  Given the following events exist:
    | name  | start       | end         | st_number | st_name   | city  | description | status    |
    | Hike  | Dec-21-2016 | Dec-21-2016 | 1210      | street rd | SF    | A hike      | approved  |
    | Hike4 | Dec-30-2016 | Dec-30-2016 | 1210      | street rd | SF    | A hike      | approved  |
    | Hike2 | Dec-25-2016 | Dec-25-2016 | 1210      | street rd | SF    | A hike      | pending   |
    | Hike3 | Dec-27-2016 | Dec-27-2016 | 1210      | street rd | SF    | A hike      | rejected  |

    And   I am on the "Admin" page
    When  I am logged in as the admin
    Then  I see the "Admin" panel
    And   I see the following status tabs: "Upcoming", "Pending", "Rejected", "Past"
    And   the date is "12/25/2016 06:00:00 AM"
    

Scenario: show upcoming events
  Given I press the "Upcoming" tab
  Then  I should only see approved, upcoming events
  And   I should see events with dates after "6:00 AM" today
  And   I should see the events sorted by date in ascending order
  And   I should not see events with dates before "6:00 AM" today

Scenario: show past events
  Given I press the "Past" tab
  Then  I should see past events
  And   I should see the events sorted by date in "descending" order
  And   I should see events with dates before "6:00 AM" today
  And   I should not see events with dates after "6:00 AM" today

Scenario: show pending events
  Given I press the "Pending" status tab
  Then  I should see pending events
  And   I should see the events sorted by date in "ascending" order
  And   I should not see events with dates before "6:00 AM" today
  And   I should not see the following event statuses: approved, rejected, past 
  
Scenario: show rejected events
  Given I press the "Rejected" status tab
  Then  I should see rejected events
  And   I should see the events sorted by date in "ascending" order
  And   I should not see the following event statuses: approved, upcoming, past 