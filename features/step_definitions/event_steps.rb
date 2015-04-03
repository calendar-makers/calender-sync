Given /the following events exist/ do |events_table|
  events_table.hashes.each do |event|
    Event.create!(event)
  end
end

Given /(?:|I )should see the following fields: "(.*)"$/ do |fields|
  fields.split(', ').each do |field|
    field = field.rstrip
    expect(page).to have_content(field)
  end
end

Then /(?:|I )should see the "(.*)" button$/ do |button_name|
  expect(page).to have_button(button_name)
end

Then /(?:|I )should see(?:| the) "(.*)" on the page$/ do |content|
  expect(page).to have_content(content)
end

And /^(?:|I )fill in the "(.*)" field with "(.*)"$/ do |field, value|
  field = find_field(field)
  field.set value
end

And /^I select "([^"]*)" as the date and time$/ do |value|
  dt  = DateTime.strptime(value, "%m/%d/%Y, %H:%M%p")
  select dt.year, :from => 'event_start_1i'
  select dt.strftime("%B"), :from => 'event_start_2i'
  select dt.day, :from => 'event_start_3i' 
  select dt.hour, :from => 'event_start_4i'
  select dt.min, :from => 'event_start_5i'
end

Then /(?:|I )should see "(.*)" link on "(.*)"$/ do |event_link, date|
  expect(page).to have_link(event_link)
  ## NEEDS MORE WORK TO CHECK THAT THE LINK IS ACTUALLY UNDER THE GIVEN DATE
  ## OR MAYBE SHOULD BE CHECKED SOMEWHERE ELSE???
end

=begin
Then /(?:|I )should see "(.*)"$/ do |value|
  #Very poorly made test, avoid using 
  pending
  #possible failures if duplicates exist.
  #expect(page).to have_content(value)
end
=end

Then /(?:|I )should see the "(.*)" link$/ do |link|
  expect(page).to have_link(link)
end

Then /(?:|I )should not see the "(.*)" link$/ do |link|
  expect(page).to_not have_link(link)
end
=begin
Then /(?:|I )should not see "(.*)"$/ do |value|
  expect(page).to_not have_content(value)
end
=end

Then /(?:|I )should see the flash message "(.*)"$/ do |message|
  @message == message
end

Then /the "(.*)" field should be populated with "(.*)"$/ do |field, value|
  expect(field_labeled(field).value).to match(/#{value}/)
end

Then /the "(.*)" time field should be populated with "(.*)"$/ do |field, value|
  field = field.downcase
  date_time = DateTime.strptime(value, "%m/%d/%Y, %H:%M%p")
  expect(page).to have_field("event_#{field}_1i", with: date_time.year)
  expect(page).to have_field("event_#{field}_2i", with: date_time.month)
  expect(page).to have_field("event_#{field}_3i", with: date_time.day)
  expect(page).to have_field("event_#{field}_4i", with: date_time.hour)
  expect(page).to have_field("event_#{field}_5i", with: date_time.min)
end

Then /the "(.*)" field should not be populated$/ do |field|
  expect(field.labeled(field).value).to eq("")
end

Given /^that I am logged in as "(.*)"$/ do |user_type|
  pending
end

Then /^I should not see the "(.*)" event$/ do |event_name|
  #pending based on calendar population, use "I should not see" for now
  pending
end

Then(/^I should see filter\/search options$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see calendar navigation tools$/) do
  pending # express the regexp above with the code you wish you had
end

Given /^(?:|I )am on the "(.*)" page for "(.*)"$/ do |page_name, event_name|
  visit path_to_event(page_name, event_name)
end

Given /^(?:|I )am on the "(.*)" page$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )click on the "(.*)" link$/ do |link|
  click_link(link)
end

When /^(?:|I )click on the "(.*)" button$/ do |button|
  click_button(button)
end

Then /^(?:|I )should see "(.*)" as the "(.*)"$/ do |value, field|
  pending
  field = field.downcase
  field = find_by_id(field)
  expect(field).to have_content(value)
end

Then /^(?:|I )should be on the "(.*)" page for "(.*)"$/ do |page_name, event_name|
  current_path = URI.parse(current_url).path
  expect(path_to_event(page_name, event_name)).to eq(current_path)
end

Then /^(?:|I )should be on the "(.*)" page$/ do |page_name|
  current_path = URI.parse(current_url).path
  expect(path_to(page_name)).to eq(current_path)
end

Given(/^"(.*)" exists$/) do |arg|
  expect(page).to have_content(arg)
end

def path_to_event(page_name, event_name)
  page_name = page_name.downcase
  path_to("the #{page_name} page for #{event_name}")
end
