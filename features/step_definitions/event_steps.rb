Given /the following events exist/ do |events_table|
  events_table.hashes.each do |event|
    Event.create!(event)
  end
end

Given /(?:|I )should see the following fields: "(.*)"$/ do |fields|
  fields.split(', ').each do |field|
    field = field.rstrip
    page.should have_content(field)
  end
end

Then /(?:|I )should see the "(.*)" button$/ do |button_name|
  page.should have_button(button_name)
end

Then /(?:|I )should see the "(.*)" on the page$/ do |field|
  page.should have_content(field)
end

And /^(?:|I )fill in the "(.*)" field with "(.*)"$/ do |field, value|
  field = find_field(field)
  field.set value
end

And /^I select "([^"]*)" as the date$/ do |date|
  date = Date.strptime(date, '%m/%d/%Y')
  select date.year, :from => 'event_start_1i'
  select date.strftime("%B"), :from => 'event_start_2i'
  select date.day, :from => 'event_start_3i' 
end

And /^I select "([^"]*)" as the time$/ do |time|
  time = Time.parse(time)
  select time.hour, :from => 'event_start_4i'
  select time.min, :from => 'event_start_5i'
end

Then /(?:|I )should see "(.*)" link on "(.*)"$/ do |event_link, date|
  page.should have_link(event_link)
  ## NEEDS MORE WORK TO CHECK THAT THE LINK IS ACTUALLY UNDER THE GIVEN DATE
  ## OR MAYBE SHOULD BE CHECKED SOMEWHERE ELSE???
end

=begin
Then /(?:|I )should see "(.*)"$/ do |value|
  #Very poorly made test, avoid using 
  pending
  #possible failures if duplicates exist.
  #page.should have_content(value)
end
=end

Then /(?:|I )should see the "(.*)" link$/ do |link|
  page.should have_link(link)
end

Then /(?:|I )should not see "(.*)" link$/ do |link|
  page.should_not have_link(link)
end
=begin
Then /(?:|I )should not see "(.*)"$/ do |value|
  page.should_not have_content(value)
end
=end

Then /(?:|I )should see the flash message "(.*)"$/ do |message|
  @message == message
end

Then /the "(.*)" field should be populated with "(.*)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end

Then /the "(.*)" time field should be populated with "(.*)"$/ do |field, value|
  date_time = DateTime.strptime(value, "%m/%d/%Y, %H:%M%p")
  page.should have_field("event_#{field}_1i", with: date_time.year)
  page.should have_field("event_#{field}_2i", with: date_time.month)
  page.should have_field("event_#{field}_3i", with: date_time.day)
  page.should have_field("event_#{field}_4i", with: date_time.hour)
  page.should have_field("event_#{field}_5i", with: date_time.min)
end

Then /the "(.*)" field should not be populated$/ do |field|
  field.labeled(field).value.should =~ ""
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
  field = find_by_id(field)
  field.should have_content(value)
end

Then /^(?:|I )should be on the "(.*)" page for "(.*)"$/ do |page_name, event_name|
  current_path = URI.parse(current_url).path
  path_to_event(page_name, event_name) != current_path
end

Then /^(?:|I )should be on the "(.*)" page$/ do |page_name|
  current_path = URI.parse(current_url).path
  path_to(page_name) == current_path
end

Given(/^"(.*)" exists$/) do |arg|
  page.should have_content(arg)
end

def path_to(page_name)
  page_name = page_name.downcase
  case page_name
    when /^calendar$/ then '/calendar'
    when /^events directory/ then '/events'
    when /^create/ then '/events/new'
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                  "Now, go and add a mapping in #{__FILE__}"
      end
  end
end

def path_to_event(page_name, event_name)
  page_name = page_name.downcase
  case page_name
    when /^details/ then "/events/#{Event.find_by_name(event_name).id}"
    when /^edit/ then "/events/#/#{Event.find_by_name(event_name).id}/edit"
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
              "Now, go and add a mapping in #{__FILE__}"
    end
  end
end
