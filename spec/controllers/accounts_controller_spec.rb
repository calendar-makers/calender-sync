require 'rails_helper'

describe AccountsController do
  before(:each) do
    @root = User.create(email: "root@root.com",
                        password: "password",
                        level: 0)
    @admin = User.create(email: "admin@admin.com",
                         password: "password")
  end
  after(:each) do
    sign_out(@admin)
    sign_out(@root)
  end

  describe '#new' do
    it 'can be accessed by root' do
      sign_in @root
      get :new
      expect(response).to render_template(:new)
    end
    it 'cannot be accessed by non-root admin' do
      sign_in @admin
      get :new
      expect(response).to redirect_to(calendar_path)
    end
    it 'cannot be accessed by guest' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
