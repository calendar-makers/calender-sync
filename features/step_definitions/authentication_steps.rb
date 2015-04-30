# Utility methods based on https://github.com/RailsApps/rails3-devise-rspec-cucumber/blob/master/features/step_definitions/user_steps.rb

def find_user
  @user ||= User.where(email: "example@example.com").first
end

def create_user
  delete_user
  @user = User.create(email: "example@example.com", 
                      password: "changeme")
end

def create_root
  delete_user
  @user = User.create(email: "example@example.com",
                      password: "changeme",
                      level: 0)
end

def delete_user
  @user ||= User.where(email: "example@example.com").first
  @user.destroy unless @user.nil?
end

def sign_in(level)
  if level == 0
    create_root
  elsif level == 1
    create_user
  end
  sign_out
  visit '/users/sign_in'
  find_field("user_email").set @user[:email]
  find_field("user_password").set "changeme"
  click_button "Log in"
end

def invalid_sign_in(level)
  if level == 0
    create_root
  elsif level == 1
    create_user
  end
  sign_out
  visit '/users/sign_in'
  find_field("user_email").set "example@example.com"
  find_field("user_password").set "incorrect password"
  click_button "Log in"
end

def sign_out
  get '/users/sign_out'
end

def create_account(valid)
  visit '/accounts/new'
  if valid
    find_field("user_email").set "admin@admin.com"
    find_field("user_password").set "password"
  elsif
    find_field("user_email").set "fail"
    find_field("user_password").set "fail"
  end
  click_button "Create Admin"
end

Given /^I am( not | )logged in as the( root | | non-root )admin$/ do |negative, root|
  if negative == ' not '
    sign_out 
  elsif root == ' root '
    sign_in(0)
  else
    sign_in(1)
  end
end

Given /^I create (a|an)( invalid | duplicate | )admin account$/ do |an, param|
  if param == ' duplicate '
    create_account(true)
    create_account(true)
  elsif param == ' invalid '
    create_account(false)
  else
    create_account(true)
  end
end

When /^I sign in with valid credentials( as root|)$/ do |root|
  if root == ' as root'
    sign_in(0)
  else
    sign_in(1)
  end
end

When /^I sign in with the wrong password( as root|)$/ do |root|
  if root == ' as root'
    invalid_sign_in(0)
  else
    invalid_sign_in(1)
  end
end

Then /^I should( not | )see the( default | | root )admin actions$/ do |negative, root|
  if negative == ' not '
    expect(page).to_not have_link('Create new event')
    expect(page).to_not have_link('Add 3rd Party Events')
    expect(page).to_not have_link('Sign Out')
    if root == ' root '
      expect(page).to_not have_link('Create new user')
    end
  else
    expect(page).to have_link('Create new event')
    expect(page).to have_link('Add 3rd Party Events')
    expect(page).to have_link('Sign Out')
    if root == 'root '
      expect(page).to have_link('Create new user')
    end
  end
end
