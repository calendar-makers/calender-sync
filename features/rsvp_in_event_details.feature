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
  | first_name | last_name | phone      | email            | address            | is_anon |
  | John       | Smith     | 8165678521 | jsmith@site.com  | 12 Washington Blvd | False   |
  | Jacob      | Harrison  | 9321234567 | jharry@gmail.com | 10 Whatever St     | True    |
  | Adam       | Johnson   | 1239874321 | ajohns@yahoo.com | 38 Smithsonian Ave | True    |
  | Mary       | Jackson   | 7894258967 | mjacks@msn.com   | 98 White Horse Ave | True    |
  | Max        | Leroy     | 7231238900 | maxler@aol.com   | 69 Feeling St      | False   |

  And the following registrations exist:
  | event_id | guest_id |
  | 1        | 1        |
  | 1        | 2        |
  | 1        | 3        |
  | 2        | 1        |
  | 2        | 2        |
  | 2        | 4        |
  | 2        | 5        |

  And I am on the "Nature Walk" page
  Then I should see the RSVP form

Scenario: RSVP form, completed and submitted
  When I fill out the RSVP form
  And I press "Submit"
  Then I should see a message confirming my submission
  And I should see my information on the page

Scenario: Attempt submission of incomplete RSVP form
  When I do not fill out the entire RSVP form
  And I press "Submit"
  Then I should see a failed submission message
  And I should not see my information on the page
