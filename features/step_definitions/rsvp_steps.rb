require_relative 'helper_steps'
<<<<<<< HEAD
=======
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
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8

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

<<<<<<< HEAD
Then(/^I should see attendees of "(.*)" listed alphabetically by last name$/) do |event_name|
  event = Event.find_by_name(event_name)
  ordered_guests = event.guests.order(:last_name)
  prev_guest = nil
  ordered_guests.each do |guest|
    puts guest
    if (prev_guest != nil) && (prev_guest != '')
      assert page.body.match(/<td>#{prev_guest.last_name}<\/td>(.*)<td>#{guest.last_name}<\/td>/m), "#{prev_guest} is not before #{guest}"
=======
Then(/^I should see info about people attending "(.*)"$/) do |event_name|
  pending
  guests = Guest.where(event_id: Event.find_by_name(event_name).id)
  with_scope('#attendees') do
    guests.each do |guest|
      guest.attributes.each do |column, value|
        step %{the page should have the text "#{value}"}
      end
    end
  end
end

Then(/^I should not see info about people who aren't attending "(.*)"$/) do |event_name|
  pending
  guests = Guest.where.not(event_id: Event.find_by_name(event_name).id)
  with_scope('#attendees') do
    guests.each do |guest|
      guest.attributes.each do |name, value|
        step %{the page should not have the text "#{value}"}
      end
    end
  end
end

Then(/^the list of attendees should be listed alphabetically by last name$/) do
  pending
  ordered_guests = Guest.order(:last_name)
  prev_guest = nil
  order_guests.each do |guest|
    if prev_guest != nil
      assert page.body.match(/<td>#{prev_guest}<\/td>(.*)<td>#{guest}<\/td>/m), "#{prev_guest} is not before #{guest}"
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
    end
    prev_guest = guest
  end
end

Then(/^I should see the RSVP form$/) do
<<<<<<< HEAD
  tags = ['guest_first_name', 'guest_last_name', 'guest_phone', 'guest_email',
          'guest_address', 'guest_is_anon_true', 'guest_is_anon_false']
  tags.each do |tag|
    expect(page).to have_css("##{tag}")
  end
end

When(/^I fill out and submit the RSVP form (anonymously|non-anonymously)$/) do |anon|
  fill_in('guest_first_name', :with => 'Alexander')
  fill_in('guest_last_name', :with => 'Hamilton')
  fill_in('guest_phone', :with => '956-975-1475')
  fill_in('guest_email', :with => 'aHamil@usa.com')
  fill_in('guest_address', :with => '12 New England Blvd')
  if anon == 'anonymously'
    choose('guest_is_anon_true')
  else
    choose('guest_is_anon_false')
  end
  click_button('Submit')
end

Then(/^I should see a message confirming my submission$/) do
  step %{the page should have the text "You successfully registered for this event!"}
=======
  pending
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

When(/^I press "(.*)"$/) do |button|
  click_button(button)
end

Then(/^I should see a message confirming my submission$/) do
  step %{the page should have the text "You've successfully registered for this event!"}
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
end

Then(/^I should( not)? see my information on the page$/) do |should_not|
  if should_not
<<<<<<< HEAD
    step %{the page should not have the text "Alexander Hamilton"}
  else
    step %{the page should have the text "Alexander Hamilton"}
=======
    step %{the page should have the text "Please fill out all fields to RSVP."}
  else
    step %{the page should not have the text "Please fill out all fields to RSVP."}
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
  end
end

When(/^I do not fill out the entire RSVP form$/) do
<<<<<<< HEAD
  fill_in('guest_first_name', :with => 'Alexander')
  fill_in('guest_last_name', :with => 'Hamilton')
end

When(/^I press "(.*)"$/) do |button|
  click_button(button)
=======
  fill_in('first_name', :with => 'Alexander')
  fill_in('last_name', :with => 'Hamilton')
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
end

Then(/^I should see a failed submission message$/) do
  step %{the page should have the text "Please fill out all fields to RSVP."}
end
<<<<<<< HEAD


Then(/^the page should( not)? have the text "(.*)"$/) do |should_not, text|
  if should_not
    expect(page).to have_no_content(text)
  else
    expect(page).to have_content(text)
  end
end
=======
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
