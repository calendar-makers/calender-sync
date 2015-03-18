# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^Calendar$/ then calendar_path
    when /^Events Directory$/ then events_path
    when /^Create$/ then new_event_path

    when /^RSVP$/ then pending # Vincent and Mike need to replace 'pending'
    when /^Meetup Login$/ then pending # Vincent and Mike need to replace 'pending'

    when /^the (.*) page for (.*)$/
      if $1 == 'details'
        event_path(Event.find_by_name($2).id)
      else
        "/events/#{Event.find_by_name($2).id}/#{$1}"
      end
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
