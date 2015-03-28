class CalendarsController < ApplicationController

  def show
    #byebug

    #options = {access_token: token}
    options = {}
    meetup = Meetup.new(options)
    meetup.pull_events

  end

end
