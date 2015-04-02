require_relative 'helper_steps'

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

Then(/^I should see info about people attending "(.*)"$/) do |event_name|
  pending
  event = Event.find_by_name(event_name)
  guests = event.guests
  table_contents_under_id(guests, '#attendees', true)
end

Then(/^I should not see info about people who aren't attending "(.*)"$/) do |event_name|
  pending
  event = Event.find_by_name(event_name)
  guests = event.guests.where.not(event_id: Event.find_by_name(event_name).id)
  table_contents_under_id(guests, '#attendees', false)
end

Then(/^the list of attendees should be listed alphabetically by last name$/) do
  pending
  ordered_guests = Guest.order(:last_name)
  prev_guest = nil
  order_guests.each do |guest|
    if (prev_guest != nil) and (guest.events)
      assert page.body.match(/<td>#{prev_guest}<\/td>(.*)<td>#{guest}<\/td>/m), "#{prev_guest} is not before #{guest}"
    end
    prev_guest = guest
  end
end

Then(/^I should see the RSVP form$/) do
  expect(page).to have_css("#rsvp")
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

def table_contents_under_id(table, html_id, should_have_text)
  with_scope("#{html_id}") do
    table.each do |row|
      row.attributes.each do |column, value|
        if should_have_text
          step %{the page should have the text "#{value}"}
        else
          step %{the page should not have the text "#{value}"}
        end
      end
    end
  end
end
