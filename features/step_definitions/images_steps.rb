When(/^I upload an image$/) do
  attach_file('image', File.join(Rails.root, '/features/upload_Files/nature1.jpg'), :visible => false)
  click_button "Upload"
end

Then(/^I should see the picture "(.*)" for "(.*)"$/) do |image_name, event_name|
  id_num = Event.find_by_name(event_name).id
  expect(page).to have_xpath("//img[starts-with(@src, '/assets/#{id_num}/medium/#{image_name}')]")
end
