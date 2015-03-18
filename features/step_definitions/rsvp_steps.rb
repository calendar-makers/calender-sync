require_relative 'helper_steps'
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

Given(/^the following guests exist:$/) do |guests_table|
  guests_table.hashes.each do |guest|
    Guest.create!(guest)
  end
end

Given(/^the following registrations exist:$/) do |registrations_table|
  registrations_table.hashes.each do |registration|
    Registration.create!(registration)
  end
end

Then(/^I should see info about people attending "(.*?)"$/) do |event_name|
  guests = Guest.where()
  with_scope('#attendees') do
    guests.each do |guest|
      guest.attributes.each do |column, value|
        step %{the page should have the text "#{value}"}
      end
    end
  end
end

Then(/^I should not see info about people only attending "(.*?)"$/) do |event_name|
  guests = Guest.where()
  with_scope('tr td') do
    guests.each do |guest|
      guest.attributes.each do |name, value|
        if page.respond_to? :should_not
          expect(page).to have_no_content(value)
        else
          page.has_no_content?(value)
        end
      end
    end
  end
end

Then(/^the list of attendees should be listed alphabetically by last name$/) do |arg1|
  ordered_guests = Guest.order(:last_name)
  prev_guest = nil
  order_guests.each do |guest|
    if prev_guest != nil
      assert page.body.match(/<td>#{prev_guest}<\/td>(.*)<td>#{guest}<\/td>/m), "#{prev_guest} is not before #{guest}"
    end
    prev_guest = guest
  end
end

Then(/^I should see the RSVP form$/) do
  expect(page).to have_field("#rsvp")
end

When(/^I fill out the RSVP form (anonymously|non-anonymously)$/) do |anon|
  fill_in('first_name', :with => 'Alexander')
  fill_in('last_name', :with => 'Hamilton')
  fill_in('phone', :with => '956-975-1475')
  fill_in('email', :with => 'aHamil@usa.com')
  fill_in('address', :with => '12 New England Blvd')
  if anon == "anonymously"
    check("is_anon")
  end
end

When(/^I press "(.*?)"$/) do |button|
  click_button(button)
end

Then(/^I should see a message confirming my submission$/) do
  step %{the page should have the text "You've successfully registered for this event!"}
end

Then(/^I should( not)? see my information on the page$/) do |should_not|
  if should_not
    step %{the page should have the text "Please fill out all fields to RSVP."}
  else
    step %{the page should not have the text "Please fill out all fields to RSVP."}
  end
end

When(/^I do not fill out the entire RSVP form$/) do
  fill_in('first_name', :with => 'Alexander')
  fill_in('last_name', :with => 'Hamilton')
end

Then(/^I should see a failed submission message$/) do
  step %{the page should have the text "Please fill out all fields to RSVP."}
end
