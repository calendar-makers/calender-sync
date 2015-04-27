Feature: See images for a particular event

  As a user
  so that I have a sense of what will happen at the event
  I want to see pictures relate to the event on its details page

Background:
  Given the following events exist:
    | name             | organization       | description                               | venue_name                 | address_1      | city     | zip   | start                | end                  | how_to_find_us     | meetup_id |
    | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145 Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left | 544545444 |
    | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45 Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left| 454444444 |

  Scenario: User should see all pictures related to the event
  Given I am on the "Edit" page for "Nature Walk"
  When I upload an image
  And I am on the "details" page for "Nature Walk"
  Then I should see the picture "nature1.jpg" for "Nature Walk"