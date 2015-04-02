require 'rails_helper'

describe SessionsController, type: :controller do
  before :each do
    auth_hash = {
      "provider" => "meetup",
      "uid" => 1,
      "info" => {
        "name" => "Vincent"
      },
      "credentials" => {
        "token" => 123456,
        "expires" => true,
        "expires_at" => 2000000000,
        "refresh_token" => 654321
      }
    }

    request = double()
    allow(request).to receive_message_chain(:env, :[]).with("omniauth.auth") {auth_hash}
  end

  describe '#create' do
    it 'should create a new User' do
    end
    it 'should redirect to root' do
      post :create
      expect(response).to redirect_to('/')
    end
  end 
  
  describe '#destroy' do
    it 'should destroy the session' do
    end
    it 'should redirect to root' do
      get :destroy
      expect(response).to redirect_to('/')
    end
  end
  
  describe '#failure' do
    it 'should redirect to calendar' do
      get :failure
      expect(response).to redirect_to('/calendar')
    end
    it 'should have the expected message' do
      params = double()
      allow(params).to receive(:[]).with(:message) {"expected message"}
      get :failure
      expect(flash[:notice]).to eq("expected message")
    end
  end 
end
