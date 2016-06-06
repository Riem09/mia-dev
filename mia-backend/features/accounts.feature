@javascript
Feature: User Accounts

  Scenario: Sign up as a new user
    Given I am an anonymous user
    When I visit the sign up page
    And I sign up with my account details
    Then I should see the sign up thank you page
    When I confirm my account
    And I log in
    Then I should be logged in

  Scenario: Reset password
    Given I am a logged in user
    When I sign out
    And I go to sign in
    And I click forgot my password
    And I enter my email
    And I submit the main form
    Then I should see the password reset confirmation
    And I should receive a password reset email
    When I visit the reset password link
    And I fill in a new password
    And I submit the main form
    Then I should be on the sign in page
    When I sign in with the new credentials
    Then I should be signed in

  Scenario: Edit profile
    Given I am a logged in user
    When I go to edit my profile
    And I change my full name
    And I enter my password
    And I set a profile image
    And I submit the main form
    Then I should be on my profile
    Then my profile should have been updated
    And my profile should include the avatar