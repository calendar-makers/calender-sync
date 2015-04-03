require_relative 'helper_steps'

Given(/^the following users exist:$/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given(/^the following registrations exist:$/) do |registrations_table|
  registrations_table.hashes.each do |registration|
    Registration.create!(registration)
  end
end

Then(/^the list of attendees for "(.*)" should be sorted alphabetically by last name$/) do |event_name|
  event = Event.find_by_name(event_name)
  ordered_users = event.users.order(:last_name)
  prev_user = nil
  ordered_users.each do |user|
    if (prev_user != nil) && (prev_user != '')
      assert page.body.match(/<td>#{prev_user}<\/td>(.*)<td>#{user}<\/td>/m), "#{prev_user} is not before #{user}"
    end
    prev_user = user
  end
end

Then(/^I should see the RSVP form$/) do
  tags = ['user_first_name', 'user_last_name', 'user_phone', 'user_email',
          'user_address', 'user_is_anon_true', 'user_is_anon_false']
  tags.each do |tag|
    expect(page).to have_css("##{tag}")
  end
end

When(/^I fill out and submit the RSVP form (anonymously|non-anonymously)$/) do |anon|
  fill_in('user_first_name', :with => 'Alexander')
  fill_in('user_last_name', :with => 'Hamilton')
  fill_in('user_phone', :with => '956-975-1475')
  fill_in('user_email', :with => 'aHamil@usa.com')
  fill_in('user_address', :with => '12 New England Blvd')
  if anon == 'anonymously'
    choose('user_is_anon_true')
  else
    choose('user_is_anon_false')
  end
  click_button('Submit')
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
  fill_in('user_first_name', :with => 'Alexander')
  fill_in('user_last_name', :with => 'Hamilton')
end

When(/^I press "(.*)"$/) do |button|
  click_button(button)
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
