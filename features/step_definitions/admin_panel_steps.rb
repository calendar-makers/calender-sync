
Given /I see the "Admin" panel$/ do
    expect(page).to have_css('#events_box')
end

Given /I see the "(.*?)" status tab$/ do |tab|
    expect(page).to have_content(tab)
end

Given /I see the following status tabs: (.*?)$/ do |tabs|
    t = tabs.split(", ")
    t.map &:downcase
    t.each do |tab|
        step "I see the #{tab} status tab"
    end
end

Given /the date is "(.*?)"$/ do |date|
    ENV["T_DATE"] = DateTime.strptime(date, '%m/%d/%Y %I:%M:%S %p').to_s
end

Then /I press the "(.*?)" tab$/ do |tab|
    click_link(tab)
end

Then /^I should (?:|only )see (.*) events$/ do |stat|
    expected_status = stat.split(", ")
    if expected_status.length > 1
        expected_status.each do |status|
            expect(page).to have_content(status, :visible => true)
        end
    else
        expect(page).to have_content(expected_status[0], :visible => true)
    end
    options = %w(approved rejected past upcoming)
    options.each do |opt|
        if !(expected_status.include? opt)
            expect(page).to have_content(opt, :visible => false)
        end
    end
end

Then /^(?:|I )should( not)? see events with dates (.*) now$/ do |negation, order|
    if order.eql? 'before'
        puts 'before'
    else
        puts 'after'
    end
end

Then /I should( not)? see "(.*)" before "(.*)"/ do |negated, first_item, second_item|
<<<<<<< HEAD
  rx = /#{first_item}.*#{second_item}/m
  if negated.eql? "not"
      rx = /#{second_item}.*#{first_item}/m
  end
  expect(page.body).to have_content(rx)
=======
  rx = /#{e1}.*#{e2}/m
  if negated.eql? "not"
      rx = /#{e2}.*#{e1}/m
  end
  expect(page.body).to =~ rx
>>>>>>> fdbd89ca5fe448b4cc11730e7a9c734c34318f36
end