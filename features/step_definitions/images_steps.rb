When(/^I upload an image$/) do 
  attach_file('image', File.join(Rails.root, '/features/upload_Files/nature1.jpg'), :visible => false)
  click_button "Upload"
end

Then(/^I should see the picture "(.*)" for "(.*)"$/) do |image_name, event_name|
  id_num = Event.find_by_name(event_name).id
  puts image_name
  expect(page).to have_xpath("//img[@src=\"/public/assets/#{id_num}/medium/#{image_name}\"]")
end

Then(/^I should not see any pictures for "(.*)"$/) do |event_name|
  id_num = Event.find_by_name(event_name).id
  Dir.foreach("public/assets/#{id_num}/medium") do |item|
    next if item == '.' or item == '..'
    expect(page).to_not have_xpath("//img[@src=\"/assets/#{id_num}/medium/#{item}.*\"]")
  end
end
