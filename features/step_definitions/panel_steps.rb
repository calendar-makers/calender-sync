Capybara.javascript_driver = :webkit

Then(/^I should see the Event Details panel$/) do
  pending
end

And(/^it should say "(.*)"$/) do |message|
  pending
end

When(/^I click on "(.*)" in the calendar$/) do |name|
  pending
  #set @event for the other steps
end

Then(/^the panel should display "(.*)" in its "(.*)" field$/) do |value, field|
  pending
end

Then(/^the panel should display its details$/) do
  pending
end

# PANEL CRUD STEP DEFINITIONS BELOW
Then(/^I should see the "(.*)" panel$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

When(/^I create an event called "(.*)" that starts at "(.*)"$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*)" on "(.*)" on the calendar$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

When(/^I choose to edit the event "(.*)"$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

When(/^I change the start time of "(.*)" to "(.*)"$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

Then(/^I should not see "(.*)" on "(.*)" on the calendar$/) do |arg1, arg2|
    pending # express the regexp above with the code you wish you had
end

When(/^I delete the event "(.*)"$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

Then(/^"(.*)" should not be on the calendar$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end
