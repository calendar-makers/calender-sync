Feature: See images for a particular event

  As a user
  so that I have a sense of what will happen at the event
  I want to see pictures relate to the event on its details page

Background:
  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

Scenario: User should see all pictures related to the event
  When I am on the "Nature Walk" page
  Then I should see all the pictures for "Nature Walk"
  And I should not see any pictures for "Green Bean Mixer"
