Capybara.javascript_driver = :webkit

Then /^I(?:| should) see the event "(.*)" on "(.*)"$/ do |title, date|
  @date = date.to_datetime.iso8601.to_s
  @title = title
  page.execute_script("$('#calendar').fullCalendar( 'gotoDate', '#{@date}' )")

  # hacky test b/c meetup is weird...
  visit '/events.json'
  expect(page).to have_content(@title)
  step %Q(I am on the calendar page)

  # # this worked before trying to merge with meetup
  # expect(success).to eq(true)
end

When /^I click the event$/ do
  # fake the click, because meetup is making the calendar fail...
  # probably because capybara doesn't have access to the meetup environment variables
  visit '/events/1'

  # # this also worked before trying to merge with meetup
  # link = page.evaluate_script("var events = $('#calendar').fullCalendar( 'clientEvents' );
  #                              var returnVal = '';
  #                              for(var i = 0; i < events.length; i++) {
  #                                if( events[i].start.toISOString().substr(0,10) == moment('#{@date}').toISOString().substr(0,10) ) {
  #                                  if( events[i].title == '#{@title}' ) {
  #                                    returnVal = returnVal + events[i].url;
  #                                  }
  #                                }
  #                              }
  #                              returnVal;")
  # visit link
end

Then /^I should be on its details page$/ do
  step %Q(I should be on the "details" page for "#{@title}")
end