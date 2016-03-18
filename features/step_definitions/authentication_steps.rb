# Utility methods based on https://github.com/RailsApps/rails3-devise-rspec-cucumber/blob/master/features/step_definitions/user_steps.rb

Capybara.javascript_driver = :webkit

def find_user
  @user ||= User.where(email: "example@example.com").first
end

def create_user
  delete_user
  @user = User.create(email: "example@example.com",
                      password: "changeme",
                      reset_password_token: "token")
end

def create_root
  delete_user
  @user = User.create(email: "example@example.com",
                      password: "changeme",
                      reset_password_token: "token",
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

def delete_account
  visit '/accounts/root/edit'
  page.driver.browser.accept_js_confirms
  click_link "Delete Account"
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

When /^I delete an existing account$/ do
  create_account(true)
  delete_account
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
    if root != ' root '
      expect(page).to_not have_link('Change your password')
      expect(page).to_not have_link('Sign Out')
    else
      expect(page).to_not have_link('Create new account')
      expect(page).to_not have_link('Delete existing accounts')
    end
  else
    if root != ' root '
      expect(page).to have_link('Change your password')
      expect(page).to have_link('Sign Out')
    else
      expect(page).to have_link('Create new account')
      expect(page).to have_link('Delete existing accounts')
    end
  end
end
