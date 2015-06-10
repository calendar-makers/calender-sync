class AdminMailer < ActionMailer::Base
  default from: "info@natureinthecity.org"
  def admin_email(guest, event)
    @guest = guest
    @event = event
    mail(to: "info@natureinthecity.org", subject: "RSVP for #{@event.name}")
  end
end
