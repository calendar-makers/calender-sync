require_relative 'helper_steps'
require 'httparty'
require 'cucumber/rspec/doubles'

Given /^I have (not )?(?:already )?logged in as an admin on Meetup$/ do |did_login|
  # For the moment just using the API key
  # But push and edit actions can only be done by her
end

Given /^the following events exist on Meetup:$/ do |events_table|
  #no-op
end

And /^the Meetup events "(.*)" should (not )?exist$/ do |event_names, negative|
  event_names = event_names.split(',')
  event_names.each do |name|
    name.strip!
    if negative
      expect(Event.find_by_name(name)).to be_nil
    else
      expect(Event.find_by_name(name)).not_to be_nil
    end
  end

end

Given /^I attempt to go to the "(.*)" page?$/ do |page_name|
  fake_data = double
  allow(fake_data).to receive(:code).and_return(404)
  allow(HTTParty).to receive(:get).and_return(fake_data)
  visit path_to(page_name)
end

And /^the "(.*)" event with id "(.*)" has the following RSVP list:$/ do |platform, id, table|

end

And /^I pull the meetup event with id: "(.*)"?/ do |id|

end

And /^I go to the "details" page for event id: "(.*)"$/ do |id|
  step %Q{I am on the "details" page for "#{Event.find_by_id(id).name}"}
end

Then /^I should (not )?see the following RSVP list:$/ do |negative, table|

end

And /^I should (not )?see the list "(.*)" containing: "(.*)"$/ do |negative, list_type, list_content|

end

And /^I should see the "(.*)" buttons$/ do |buttons|
  buttons.split(',').each do |button|
    step %Q{I should see the "#{button.strip}" button}
  end

end

And /^I (un)?check "(.*)" for "(.*)"$/ do |negative, check_box, entries|
  check(entries)
end

And /^I should (not )?see the "(.*)" links$/ do |negative, links|
  links.split(',').each do |link|
    step %Q{I should #{negative}see the "#{link.strip}" link}
  end
end

And /^the following organizations are (not )?saved:$/ do |negative, table|

end

And /^I searched an event id "(.*)"$/ do |id|
  step %Q{I fill in the "ID" field with "#{id}"}
  step %Q{I click on the "Search" button}
end

