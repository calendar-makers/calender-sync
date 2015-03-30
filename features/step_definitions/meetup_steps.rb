require_relative 'helper_steps'

Given /^I have (not )?(?:already )?logged in as an admin on Meetup$/ do |did_login|
  # For the moment just using the API key
  # But push and edit actions can only be done by her
end

Given /^the following events exist on Meetup:$/ do |events_table|
  events_table.hashes.each do |event|
    #Event.create!(event)
  end
end

And /^the "(.*)" event "(.*)" should (not )?exist$/ do |platform, event_name, negative|

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

end

And /^I should (not )?see the "(.*)" links$/ do |negative, links|
  links.split(',').each do |link|
    step %Q{I should #{negative}see the "#{link.strip}" link}
  end
end

And /^the following organizations are (not )?saved:$/ do |negative, table|

end


