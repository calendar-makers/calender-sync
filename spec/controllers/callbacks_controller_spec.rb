require 'spec_helper'
require 'rails_helper'

describe CallbacksController, type: :controller do
  before :each do
    OmniAuth.config.test_mode = true
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:meetup] = {
      "provider"=>"meetup",
      "uid"=>"10101",
      "credentials"=>{"token"=>"token", "expires_at"=>3600, "refresh_token"=>"refresh_token"}
    }
  end

  after :each do
    OmniAuth.config.test_mode = false
  end
  
  @omniauth_test
  describe '#meetup' do
    it 'should be successful' do
      # controller.meetup
    end
    it 'should create a user' do
      # expect(User.where()).to exist
    end
    it 'should sign in' do
    end
    it 'should redirect' do
    end 
  end
end
