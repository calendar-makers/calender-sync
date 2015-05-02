class GuestMailerPreview < ActionMailer::Preview
  def rsvp_email_preview
    GuestMailer.rsvp_email(Guest.first)
  end
end
