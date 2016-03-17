# in features/admin_panel/collapse_event_details.feature

Feature: Hide the details of events displayed in the admin panel
  As an admin
  So that the admin panel isn’t cluttered
  I want to be able to collapse and expand event details
  
  Background:
    Given the following events exist:
    | name  | start         | end           | st_number | st_name   | city  | description   | status    |
    | Hike1 | 12/21/2016    | 12/21/2016    | 1210      | street rd | SF    | A hike        | approved  |
    | Hike2 | 12/25/2016    | 12/25/2016    | 1210      | street rd | SF    | A hike        | pending   |
    | Hike3 | 12/27/2016    | 12/27/2016    | 1210      | street rd | SF    | A hike        | rejected  |
    | Hike4 | 12/30/2016    | 12/30/2016    | 1210      | street rd | SF    | A hike        | approved  |
    | Hike5 | 12/31/2016    | 12/31/2016    | 1210      | street rd | SF    | A hike        | approved  |
    
    And I am logged in as the admin
    And I see the "Admin" panel
    And the date is "12/25/2016 06:00:00 AM"

Scenario: Event details should be collapsed when you first visit the page
  Given I am displaying "Upcoming" events
  Then I should see "Hike4"
  And the details of "Hike4" should be hidden
  When I press the "Rejected" tab
  Then I should see "Hike3"
  And the details of "Hike3" should be hidden
  
Scenario: Event details should be visible when you click "Show More"
  Given I am displaying "Upcoming" events
  Then I should see "Hike4"
  And the details of "Hike4" should be hidden
  When I press "Show More" on "Hike4"
  Then the details of "Hike4" should not be hidden

Scenario: Event details should be hidden again when you click "Show Less"
  Given I am displaying "Upcoming" events
  And I display the details of "Hike4"
  When I press "Show Less" on "Hike4"
  Then the details of "Hike4" should be hidden

Scenario: Displayed event details should be displayed after returning from another tab
  Given I am displaying "Upcoming" events
  When I press "Show More" on "Hike4"
  Then I press the "Past" tab
  And I press "Show More" on "Hike1"
  When I press "Upcoming"
  Then the details of "Hike4" should not be hidden
  But the details of "Hike5" should be hidden