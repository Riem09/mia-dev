Feature: Upload a video

  @javascript
  Scenario: A user uploads a video
    Given I am a logged in user
    When I go to add a video
    And I fill in the video title with "asldf"
    And I upload a video
    And I submit the video form
    Then I should see "asldf"
    And I should be on the video page
    And I should see "MIA is processing the video. This may take a few minutes."
    When the uploaded video has finished processing
    And I view the uploaded video
    Then I should see the video upload
