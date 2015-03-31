class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.expires_at = auth["credentials"]["expires_at"]
      user.refresh_token = auth["credentials"]["refresh_token"]
    end
  end
end
