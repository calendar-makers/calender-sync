# Utility methods based on https://github.com/RailsApps/rails3-devise-rspec-cucumber/blob/master/features/step_definitions/user_steps.rb

def find_user
  @user ||= User.where(:uid => "12345").first
end

def create_user
  delete_user
  @user = User.create(:provider => "Meetup", :uid => "12345",
                      :email => "example@example.com", 
                      :password => "changeme", :token => "abc", 
                      :expires_at => 0, :refresh_token => "def")
end

def delete_user
  @user ||= User.where(:uid => "12345").first
  @user.destroy unless @user.nil?
end

def sign_in
  create_user
  sign_out
  visit '/users/sign_in'
  find_field("user_email").set @user[:email]
  find_field("user_password").set "changeme"
  click_button "Log in"
end

def invalid_sign_in
  create_user
  sign_out
  visit '/users/sign_in'
  find_field("user_email").set "example@example.com"
  find_field("user_password").set "incorrect password"
  click_button "Log in"
end

def sign_in_with_meetup
  sign_out
  visit new_user_session_path
  click_link 'Sign in with Meetup'
end

def sign_out
  get 'users/sign_out'
end

Given /^I am( not | )logged in as the admin$/ do |negative|
  if negative == ' not '
    sign_out 
  else
    sign_in
  end
end

When /^I sign in with valid credentials$/ do
  sign_in
end

When /^I sign in with the wrong password$/ do
  invalid_sign_in
end

# Test is all false positives for some reason
Then /^I should( not | )see the admin actions$/ do |negative|
  if negative == ' not '
    expect(page).to_not have_link('Create new event')
    expect(page).to_not have_link('Add 3rd Party Events')
    expect(page).to_not have_link('Sign Out')
  else
    expect(page).to have_link('Create new event')
    expect(page).to have_link('Add 3rd Party Events')
    expect(page).to have_link('Sign Out')
  end
end
