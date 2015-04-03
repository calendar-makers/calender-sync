# Helper step definitions. Please don't use these steps directly in feature
# files, except for maybe When(/^I press "(.*)"$/).

<<<<<<< HEAD
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

When(/^(.*) within (.*[^:])$/) do |step_string, parent|
  with_scope(parent) { step %{#{step_string}} }
=======
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
>>>>>>> 3a3b7d8334a271907db884dd25e901be52f884e8
end
