class GuestMailer < ActionMailer::Base
  default from: "mailbot@cal-sync.herokuapp.com"
  def rsvp_email(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email, subject: "RSVP for #{@event.name}")
  end
end
