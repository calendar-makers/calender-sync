Feature: User can RSVP for event through event details page

  As a vistor of the website
  So that I can join the event with minimal overhead
  I want to be able to RSVP for the event

Background:
  Given the following events exist:
  | name             | organization       | description                               | start               | location                   |
  | Nature Walk      | Nature in the City | A walk through the city                   | March 19 2015 16:30 | The old Town Hall          |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | March 12 2015 00:00 | San Francisco City Library |

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
