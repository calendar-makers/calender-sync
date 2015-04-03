# Helper step definitions. Please don't use these steps directly in feature
# files, except for maybe When(/^I press "(.*)"$/).

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
end
