require 'spec_helper'
require 'rails_helper'

describe ApplicationController, type: :controller do
  before :each do
    @user = User.create(provider: "meetup", uid: 101, token: "token", expires_at: 0, refresh_token: "refesh_token")
  end

  describe '#current_user' do
    it 'should return nil if user not logged in' do
      expect(controller.current_user).to be_nil
    end
    it 'should return current user if user is logged in' do
      controller.stub(:current_user).and_return(@user)
      expect(controller.current_user).to eq(@user)
    end
  end
end
