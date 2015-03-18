# Helper step definitions. Please don't use these steps directly in feature
# files, except for maybe When(/^I press "(.*)"$/).

Then(/^the page should have the text "(.*)"$/) do |text|
  if page.respond_to? :should
     page.should have_content(text)
  else
     page.has_content?(text)
  end
end

Then(/^the page should not have the text "(.*)"$/) do |text|
  if page.respond_to? :should
     page.should have_no_content(text)
  else
     page.has_no_content?(text)
  end
end
