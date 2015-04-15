Capybara.javascript_driver = :webkit

Then(/^I should see the default panel$/) do
  pending
end

And(/^it should say "(.*)"$/) do |message|
  pending
end

When(/^I click on "(.*)" in the calendar$/) do |name|
  pending
  #set @event for the other steps
end

Then(/^the panel should display "(.*)" as the heading$/)
  pending
end

Then(/^the panel should display "(.*)" in its "(.*)" field$/) do |value, field|
  pending
end

Then(/^the panel should display the description for "(.*)"$/) do |event|
  pending
end

# PANEL CRUD STEP DEFINITIONS BELOW
Then(/^I should see the "(.*)" panel$/) do |operation|
  pending # express the regexp above with the code you wish you had
end

When(/^I create an event called "(.*)" that starts at "(.*)"$/) do |name, time|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*)" on "(.*)" on the calendar$/) do |name, date|
  pending # express the regexp above with the code you wish you had
end

When(/^I choose to edit the event "(.*)"$/) do |name|
  pending # express the regexp above with the code you wish you had
end

When(/^I change the start time of "(.*)" to "(.*)"$/) do |name, time|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see "(.*)" on "(.*)" on the calendar$/) do |name, time|
  pending # express the regexp above with the code you wish you had
end

When(/^I delete the event "(.*)"$/) do |name|
  pending # express the regexp above with the code you wish you had
end

Then(/^"(.*)" should not be on the calendar$/) do |name|
  pending # express the regexp above with the code you wish you had
end
