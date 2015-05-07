When(/^I upload an image for "(.*)"$/) do |event_name|
  click_button('Edit')
  attach_file('image', File.join(Rails.root, '/features/upload_files/nature1.jpg'), :visible => false)
  click_button('Save Event')
end

Then(/^I should see the picture "(.*)" for "(.*)"$/) do |image_name, event_name|
  sleep(2)
  step %{I click on "#{event_name}" in the calendar}
  id_num = Event.find_by_name(event_name).id
  expect(page).to have_xpath("//img[starts-with(@src, '/assets/#{id_num}/original/#{image_name}')]")
end
