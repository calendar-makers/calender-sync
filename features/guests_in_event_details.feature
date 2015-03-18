Feature: See who RSVPed for event

  As a user
  So that I can predict who's attending the event
  I want to be able to view who has RSVPed to the event

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

Scenario: User sees all event attendees
  When I am on the "Nature Walk" page
  Then I should see info about people attending "Nature Walk"
  And I should not see info about people only attending "Green Bean Mixer"
  And the list of attendees should be listed alphabetically by "last_name"
