Feature: User can RSVP for event through event details page

  As a vistor of the website
  So that I can join the event with minimal overhead
  I want to be able to RSVP for the event

Background:
  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

  And the following guests exist:
  | first_name | last_name | phone          | email            | address            | is_anon |
  | John       | Smith     | (816) 567-8521 | jsmith@site.com  | 12 Washington Blvd | false   |
  | Jacob      | Harrison  | (932) 123-4567 | jharry@gmail.com | 10 Whatever St     | true    |
  | Adam       | Johnson   | (123) 987-4321 | ajohns@yahoo.com | 38 Smithsonian Ave | true    |
  | Mary       | Jackson   | (789) 425-8967 | mjacks@msn.com   | 98 White Horse Ave | true    |
  | Max        | Leroy     | (723) 123-8900 | maxler@aol.com   | 69 Feeling St      | false   |

  And the following registrations exist:
  | event_id | guest_id |
  | 1        | 1        |
  | 1        | 2        |
  | 1        | 3        |
  | 2        | 1        |
  | 2        | 2        |
  | 2        | 4        |
  | 2        | 5        |

  And I am on the "details" page for "Nature Walk"
  Then I should see the RSVP form

Scenario: RSVP form, completed and submitted
  When I fill out the RSVP form non-anonymously
  And I press "Submit"
  Then I should see a message confirming my submission
  And I should see my information on the page

Scenario: Attempt submission of incomplete RSVP form
  When I do not fill out the entire RSVP form
  And I press "Submit"
  Then I should see a failed submission message
  And I should not see my information on the page
