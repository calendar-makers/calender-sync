class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    ret = create do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.expires_at = auth["credentials"]["expires_at"]
      user.refresh_token = auth["credentials"]["refresh_token"]
    end
    return ret
  end

  # refresh logic.
  def token_expired?
    return Time.at(self.expires_at) <= Time.now
  end

  def get_token
    self.refresh if self.token_expired?
    return self.token
  end

  def refresh
    options = {}
    options[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
    options[:body] = {client_id: ENV["MEETUP_KEY"], client_secret: ENV["MEETUP_SECRET"], grant_type: "refresh_token", refresh_token: self.refresh_token}
    data = HTTParty.post("https://secure.meetup.com/oauth2/access", options)
    if data.code == 200
      self.token = data["access_token"]
      self.refresh_token = data["refresh_token"]
      self.expires_at = Time.now.to_i + data["expires_in"]
      self.save # remember to save changes to database!
    else
      # wat do if refresh fails? Try again? common case, refresh token already used
      raise 'Unexpected error during refresh'
    end
  end

end
