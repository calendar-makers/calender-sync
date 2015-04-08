Then(/^I should see all the pictures for "(.*)"$/) do |event_name|
  pending
  id_num = Event.find_by_name(event_name).id
  Dir.foreach("public/assets/#{id_num}/medium") do |item|
    next if item == '.' or item == '..'
    expect(page).to have_xpath("//img[@src=\"../assets/images/#{event_name}/#{item}\"]")
  end
end

Then(/^I should not see any pictures for "(.*)"$/) do |event_name|
  pending
  id_num = Event.find_by_name(event_name).id
  Dir.foreach("public/assets/#{id_num}/medium") do |item|
    next if item == '.' or item == '..'
    expect(page).to_not have_xpath("//img[@src=\"../assets/images/#{event_name}/#{item}\"]")
  end
end
