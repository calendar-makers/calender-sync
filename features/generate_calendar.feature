Feature: Display a calendar

  As a user,
  So that I can view the events in a clean and concise matter,
  I want to be able to see a calendar

Scenario: go to previous month's calendar
  Given I am on the calendar page
  When I click on the left arrow
  Then I should see the previous month

Scenario: go to next month's calendar
  Given I am on the calendar page
  When I click on the right arrow
  Then I should see the next month

Scenario: see current month and year
  Given I am on the calendar page
  Then I should see the current month and year

Scenario: days for a particular month and year are correct
  Given the month is April
  And the year is 2015
  Then the first day should be Wednesday
  And the last day should be Thursday
