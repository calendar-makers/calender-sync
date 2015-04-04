require 'rails_helper'

describe User do
  describe '#refresh' do 
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
      @user = User.create_with_omniauth(auth_hash)
    end

    it "does not refresh when not expired" do
      expect(@user.get_token).to eq("123456")
    end
  
    it "refreshes token when expired" do
      @user.update_attributes!(expires_at: Time.now)
      expect(@user.token_expired?).to be_truthy
      data = double()
      allow(HTTParty).to receive(:post) {data}
      allow(data).to receive(:code) {200}
      allow(data).to receive(:[]).with("access_token") {"012345"}
      allow(data).to receive(:[]).with("refresh_token") {"054321"}
      allow(data).to receive(:[]).with("expires_in") {3600}
      expect(@user.get_token).to eq("012345")
    end
    
    it "raises an error if 400 status code received" do
      @user.update_attributes!(expires_at: Time.now)
      expect(@user.token_expired?).to be_truthy
      data = double()
      allow(HTTParty).to receive(:post) {data}
      allow(data).to receive(:code) {400}
      expect{@user.get_token}.to raise_error("Unexpected error during refresh")
    end
  end

end
