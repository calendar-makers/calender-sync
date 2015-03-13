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
  fill_in(field, with: value)
end

And /^I select "([^"]*)" as the date$/ do |date|
  date = Date.strptime(date, '%m/%d/%Y')
  select date.year, :from => 'event_date_1i'
  select date.strftime("%B"), :from => 'event_date_2i'
  select date.day, :from => 'event_date_3i' 

  #select(date.year.to_s, :from => "#event[date(1i)]")
  #select(date.strftime("%B"), :from => "#event_date_2i")
  #select(date.day.to_s, :from => "#event_date_3i")
end

And /^I select "([^"]*)" as the time$/ do |time|
  time = Time.parse(time)
  select time.hour, :from => 'event_time_4i'
  select time.min, :from => 'event_time_5i'
end


Then /(?:|I )should see "(.*)" link on "(.*)"$/ do |event_link, date|
  page.should have_link(event_link)
  ## NEEDS MORE WORK TO CHECK THAT THE LINK IS ACTUALLY UNDER THE GIVEN DATE
  ## OR MAYBE SHOULD BE CHECKED SOMEWHERE ELSE???
end

Then /(?:|I )should see "(.*)"$/ do |value|
  page.should have_content(value)
end

Then /(?:|I )should not see "(.*)"$/ do |value|
  page.should have_content(value)
end

Then /(?:|I )should see the flash message "(.*)"$/ do |message|
  @message == message
end

Then /the "(.*)" field should be populated with "(.*)"$/ do |field_name, value|
  page.field(field_name).should have_content(value)
end

Then /the "(.*)" field should not be populated$/ do |field_name|
  page.field(field_name).should_be_unused?
end

Given /^that I am logged in as "(.*)"$/ do |user_type|
  pending
end

Then /^I should not see the "(.*)" event$/ do |event_name|
  pending
end

Then(/^I should see filter\/search options$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see calendar navigation tools$/) do
  pending # express the regexp above with the code you wish you had
end


Given /^(?:|I )am on the "(.*)" page$/ do |page_name|
  visit path_to(page_name)
end

Given /^(?:|I )am on the details page for "(.*)"$/ do |page_name|
  visit path_to(page_name)
end

Given /^(?:|I )am on the "Edit" page for "(.*)"$/ do |page_name|
  pending
end

When /^(?:|I )click on "(.*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )click on the "(.*)" button$/ do |button|
  click_button(button)
end

#Then /^(?:|I )should see "(.*)"/ do |value|
#    page.should have_content(value)
#end

#Then /^(?:|I )should see the field "(.*)"/ do |field|
#    page.should have_content(value)
#end

Then /^(?:|I )should see "(.*)" as the "(.*)"$/ do |value, field|
  field = find_by_id(field)
  field.should have_content(value)
end

Then /^(?:|I )should be on the details page for "(.*)"$/ do |event|
  current_path = URI.parse(current_url).path
  path_to(event) == current_path
end

Then /^(?:|I )should be on the "(.*)" page$/ do |page_name|
  current_path = URI.parse(current_url).path
  path_to(page_name) == current_path
end

Given(/^"(.*)" exists$/) do |arg|
  page.should have_content(arg)
end

def path_to(page_name)
  #page_name = page_name.downcase
  case page_name
    when /^Calendar$/ then '/calendar'
    when /^Events Directory/ then '/events'
    when /^Create/ then '/events/new'
    when /^(.*)$/ then "/events/#{Event.find_by(name: $1).id}"
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
