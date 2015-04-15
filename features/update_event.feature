Feature: update information of an event

  As an admin
  So that I can change the details of events I've already created
  I want to be able to update events

Background: Event has already been added to the database

  Given the following events exist:
  | name             | organization       | description                               | venue_name                 | address_1      | city     | zip   | start                | end                  | how_to_find_us     |
  | Nature Walk      | Nature in the City | A walk through the city                   | The Old Town Hall          | 145 Jackson st | Glendale | 90210 | March 19 2015, 16:30 | March 19 2015, 20:30 | First door on left |
  | Green Bean Mixer | Green Carrots      | If you like beans you'll like this event! | San Francisco City Library | 45 Seneca st   | Phoenix  | 91210 | April 20 2015, 8:30  | April 21 2015, 8:30  | Second door on left|

Scenario: navigate to edit page and see all of the information
  Given I am on the "details" page for "Nature Walk"
  When I click on the "Edit" link
  Then I should be on the "Edit" page for "Nature Walk"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Description" field should be populated with "A walk through the city"
  And the "start" time field should be populated with "3/19/2015, 4:30pm"
  And the "Venue Name" field should be populated with "The Old Town Hall"

Scenario: correctly change information results in change
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Venue Name" field with "The New Town Hall"
  And I click on the "Update Event Info" button
  Then I should be on the "Calendar" page

Scenario: make sure user correctly changes information in edit page
  Given I am on the "Edit" page for "Nature Walk"
  And I fill in the "Venue Name" field with ""
  And I click on the "Update Event Info" button
  Then I should be on the "Edit" page for "Nature Walk"
  And I should see the message "Please fill in the following fields before submitting: venue_name Event Name Organization Name Venue Name Address City Zip State"
  And the "Event Name" field should be populated with "Nature Walk"
  And the "Description" field should be populated with "A walk through the city"
  And the "Start" time field should be populated with "3/19/2015, 4:30pm"
  And the "Venue Name" field should be populated with "The Old Town Hall"
