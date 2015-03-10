Given /the following events exist/ do |events_table|
  events_table.hashes.each do |event|
    Event.create!(event)
  end
end

Given /^(?:|I )am on the "(.*)" page$/ do |page_name|
  visit path_to(page_name)
end

Given /^(?:|I )am on the details page for "(.*)"$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )click on "(.*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )click on the "(.*)" button$/ do |link|
  click_link(link)
end

Then /^(?:|I )should see the "(.*)" "(.*)"$/ do |field, value|
     page.should have_content(value)
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
  case page_name
    when /^calendar$/ then '/events'
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
