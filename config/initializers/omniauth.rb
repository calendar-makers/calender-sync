Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :meetup, ENV['MEETUP_KEY'], ENV['MEETUP_SECRET']
end

class NonExplodingFailureEndpoint < OmniAuth::FailureEndpoint
  def call
    redirect_to_failure
  end
end

OmniAuth.config.on_failure = NonExplodingFailureEndpoint
