require_relative 'helper_steps'
require 'httparty'
require 'cucumber/rspec/doubles'

Given /^I have (not )?(?:already )?logged in as an admin on Meetup$/ do |did_login|
  # For the moment just using the API key
  # But push, edit, delete actions can only be done through organizer privileges
end

Given /^the following events exist on Meetup:$/ do |events_table|
  #no-op
end

And /^the Meetup events "(.*)" should (not )?exist$/ do |event_names, negative|
  event_names.include?("'") ? (char = "'") : (char = ",")
  event_names = event_names.split(char)
  event_names.each do |name|
    name.strip!
    if negative
      expect(Event.find_by_name(name)).to be_nil
    else
      expect(Event.find_by_name(name)).not_to be_nil
    end
  end
end

Then /^break internet$/ do
  fake_data = double
  allow(fake_data).to receive(:code).and_return(404)
  allow(HTTParty).to receive(:get).and_return(fake_data)
end

Given /^I attempt to go to the "(.*)" page?$/ do |page_name|
  step %Q{break internet}
  visit path_to(page_name)
end

Given /^I attempt to click on the "(.*)" button$/ do |button_name|
  step %Q{break internet}
  step %Q{I click on the "Add Events" button}
end

And /^the "(.*)" event with id "(.*)" has the following RSVP list:$/ do |platform, id, table|

end

And /^I go to the "details" page for event id: "(.*)"$/ do |id|
  step %Q{I am on the "details" page for "#{Event.find_by_id(id).name}"}
end

Then /^I should (not )?see the following RSVP list:$/ do |negative, table|

end

And /^I should (not )?see the list "(.*)" containing: "(.*)"$/ do |negative, list, list_content|
  list_content.include?("'") ? (char = "'") : (char = ",")
  list_content = list_content.split(char)
  list_content.each do |entry|
    entry.strip!
    element = find(list)
    negative ? !element.assert_no_text(entry) : element.assert_text(entry)
  end
end

And /^I should see the "(.*)" buttons$/ do |buttons|
  buttons.split(',').each do |button|
    step %Q{I should see the "#{button.strip}" button}
  end

end

And /^I (un)?check ".+" for "(.*)"$/ do |negative, items|
  items = items.split(',')
  items.each do |item|
    item.strip!
    negative ? uncheck(item) : check(item)
  end
end

And /^I searched an event by id: "(.*)"$/ do |id|
  step %Q{I fill in the "ID" field with "#{id}"}
  step %Q{I click on the "Search" button}
end

And /^I searched events by group_urlname: "(.*)"$/ do |urlname|
  step %Q{I fill in the "Group Name" field with "#{urlname}"}
  step %Q{I click on the "Search" button}
end

