require 'rails_helper'

describe User do
  describe '#create_non_root' do
    before :each do
      @valid_params = {
        "user" => {
          "email" => "example@example.com",
          "password" => "password"
        }
      }
      @empty_params = {
        "user" => {
          "email" => "",
          "password" => ""
        }
      }
    end
    it 'creates a non root user' do
      @user = User.create_non_root(@valid_params)
      expect(@user.save).to be_truthy
    end
    it 'does not save if invalid inputs' do
      @user = User.create_non_root(@empty_params)
      expect(@user.save).to be_falsey
    end
    it 'does not save if duplicate emails' do
      @first = User.create_non_root(@valid_params)
      @first.save
      @second = User.create_non_root(@valid_params)
      expect(@second.save).to be_falsey
    end
  end
  describe '#root?' do
    before :each do
      @root = User.create!(email: "root@root.com", password: "password", level: 0)
      @non_root = User.create!(email: "user@user.com", password: "password")
    end
    it 'returns true if root' do
      expect(@root.root?).to be_truthy
    end
    it 'returns false if not root' do
      expect(@non_root.root?).to be_falsey
    end
  end

# refresh logic deprecated
=begin
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
=end
end
