Capybara.javascript_driver = :webkit

Then(/^I should see the default panel$/) do
  expect(page).to have_content("Click an event!")
end

When(/^(?:|when )I click on "(.*)" in the calendar$/) do |name|
  sleep(2)
  all('.fc-title', :text => name)[0].click
end

=begin
When(/^I click on "(.*)" in the calendar$/) do |name|
# problems.....
   expect(page).to have_selector(".fc-event-container")
   page.execute_script(<<-JAVASCRIPT)
   var handlers = $('.fc-event-container')[0].click;
   console.log("hi");
   JAVASCRIPT
   page.execute_script("$('.fc-title')[0].click;")
   p page.body
   find(:xpath, '//span[contains(., "Volunteer")').click
   page.all(".fc-title").each do |el|
     el.click
   end
   p page.execute_script("var thing = [{
                        'id':1,
                        'title':'Green Bean Mixer',
                        'start':'',
                        'end':'',
                        'location':'45 Seneca st\nPhoenix91210\n',
                        'description':'If you like beans youll like this event!',
                        'temp':'/events/1'
                      }]; thing;")
 end
=end

Then(/^the panel should display "(.*)" in its "(.*)" field$/) do |value, field|
  expect(page).to have_content("Event Details")
  expect(value).to be(value)
end

Then(/^the panel should display the (.*) and description for "(.*)"$/) do |image, name|
  expect(image).to be(image)
  step %Q(the panel should display "Description" in its "Description" field)
end

Then(/^I should see the (.*) in the panel$/) do |panel|
  case panel
  when "details"
    expect(page).to have_content("Event Details")
  when "edit form"
    expect(page).to have_content("Edit Event")
  when "new form"
    expect(page).to have_content("New Event")
  end
end

Then(/^I click on the (.*) event button$/) do |action|
  selector = '#' + action + '_event'
  page.find(selector).click
  if action == "delete"
    @d_name = "select only one"
  end
end

When(/^I change the (.*) to "(.*)"$/) do |field, value|
  case field
  when "start date"
  when "start time"
  when "end date"
  when "end time"
    datetime = value.split(" ")
    month  = datetime[0]
    day    = datetime[1]
    year   = datetime[2]
    hour   = datetime[3].split(":")[0]
    minute = datetime[3].split(":")[1]
    ampm   = datetime[4]
  end
  page.find('#update')[:value]
end

And(/^(?:|I )save the event$/) do
  page.find('#update').click
end

# revise later
Then(/^I(?:| should) see "(.*)" on "(.*)" in the calendar$/) do |name, date|
  step %Q(the month is #{@date})
  expect(page).to have_content(name)
end

Then(/^"(.*)" should (?:|not )be in the calendar$/) do |d_name|
  step %Q(the month is #{@date})
  expect(page).to_not have_content(@d_name)
end

Then(/^the panel should display a google map in its location field$/) do
  #expect(page).to have_selector('#map')
  expect(page).to have_selector('#map iframe')
end

Then(/^I should be able to specify the location through google maps$/) do
  expect(page).to have_selector('#autocomplete')
end
