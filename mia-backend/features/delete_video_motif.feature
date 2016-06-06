@javascript
Feature: Delete a video motif

  Scenario: user deletes video motif
    Given I am a logged in user
    And there is a child motif
    And there is a video with the motif
    When I view the video
    And I click on the first general motif
    And I click the video motif edit
    And I delete the video motif
    Then I should not see the child motif name