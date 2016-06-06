@javascript
Feature: Delete a video

  Scenario: User delete a video
    Given I am a logged in user
    And there is a video
    When I edit the video
    Then I should see the video title
    When I delete the video
    Then I should not see the video title
    And I should be on the video index

