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

Then(/^I should see attendees of "(.*)" listed alphabetically by first name$/) do |event_name|
  event = Event.find_by_name(event_name)
  ordered_non_anon_guests = event.guests.where(is_anon: false).order(:first_name)

  prev_guest = nil
  ordered_non_anon_guests.each do |guest|
    if (prev_guest != nil) && (prev_guest != '')
      expect(page).to have_content(/#{prev_guest.first_name}(.*)#{guest.first_name}/)
    end
    prev_guest = guest
  end
end

Then(/^I should not see anonymous attendees of "(.*)"$/) do |event_name|
  event = Event.find_by_name(event_name)
  anon_guests = event.guests.where(is_anon: true)
  anon_guests.each do |guest|
    step %{the page should not have the text "#{guest.first_name}"}
  end
end

When(/^I fill out and submit the RSVP form (anonymously|non-anonymously)$/) do |anon|
  # Fills out the required fields: First Name, Last Name, Email, and anonymity status.
  fill_in('guest_first_name', with: 'Alexander')
  fill_in('guest_last_name', with: 'Hamilton')
  fill_in('guest_email', with: 'aHamil@usa.com')
  if anon == 'anonymously'
    choose('guest_is_anon_true')
  else
    choose('guest_is_anon_false')
  end
  click_button('RSVP')
end

Then(/^I should( not)? see my first name under "(.*?)"$/) do |should_not, event_name|
  step %{I click on "#{event_name}" in the calendar}
  if should_not
    step %{the page should not have the text "Alexander"}
  else
    step %{the page should have the text "Alexander"}
  end
end

When(/^I do not fill out the all of the required fields of the RSVP form$/) do
  # Failed to fill in email and choose anonymity status.
  fill_in('guest_first_name', with: 'Alexander')
  fill_in('guest_last_name', with: 'Hamilton')
  fill_in('guest_phone', with: '956-865-1475')
  fill_in('guest_address', with: '12 Place Blvd.')
end

Then(/^the page should( not)? have the text "(.*)"$/) do |should_not, text|
  if should_not
    expect(page).to have_no_content(text)
  else
    expect(page).to have_content(text)
  end
end
