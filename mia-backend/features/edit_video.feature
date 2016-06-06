@javascript
Feature: As a user I want to edit a video

  Scenario: Edit a video title
    Given there is a video
    And I am a logged in user
    When I edit the video
    And I enter the video title "foobar"
    And I save the video
    Then I should see "foobar"
    And I should be on the video page

  Scenario: Publish a video
    Given I am a logged in user
    And there is an unpublished video
    When I visit my profile
    Then I should see the unpublished video title
    When I edit the unpublished video
    And I publish the video
    And I visit the video index
    Then I should see the unpublished video title

  Scenario: Unpublish a video
    Given I am a logged in user
    And there is a video
    When I visit my profile
    Then I should see the video title
    When I edit the video
    And I unpublish the video
    And I visit the video index
    Then I should not see the video title
