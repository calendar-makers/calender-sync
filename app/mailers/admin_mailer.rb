class AdminMailer < ActionMailer::Base
  default from: "mailbot@cal-sync.herokuapp.com"
  def admin_email(guest, event)
    @guest = guest
    @event = event
    mail(to: "mbs729@gmail.com", subject: "RSVP for #{@event.name}")
  end
end
