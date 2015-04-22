Feature: account creation

  As a root admin
  So that I can grant admin priveleges to other organization members
  I want to be able to create accounts with various privelages

Scenario: root admin should see account creation action
  Given I am logged in as the root admin
  Then I should see the default admin actions
  And I should see the account creation action

Scenario: non-root admin should not see account creation action
  Given I am logged in as the non-root admin
  Then  I should see the default admin actions
  And   I should not see the account creation action

Scenario: root admin should be able to access account creation action
  Given I am logged in as the root admin
  When  I click on the "Create new admin account" link
  Then  I should be on the "Account Creation" page

Scenario: new admin accounts can be created successfully
  Given I am logged in as the root admin
  And   I create a new admin account
  Then  I should be on the "Calendar" page
  And   I should see "Account successfully created"
