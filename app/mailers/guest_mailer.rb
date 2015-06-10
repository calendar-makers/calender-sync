class GuestMailer < ActionMailer::Base
  default from: "info@natureinthecity.org"
  def rsvp_email(guest, event)
    @guest = guest
    @event = event
    mail(to: @guest.email, subject: "RSVP for #{@event.name}")
  end
end
