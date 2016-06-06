@javascript
Feature: Edit a video motif

  Scenario: general motif
    Given I am a logged in user
    And there is a root motif
    And there is a root motif with an icon
    And there is a video with the motif
    When I view the video
    And I click on the first general motif
    Then I should be on the video page
    And I should see the scrub for the general motif
    When I click the video motif edit

  Scenario: timestamped motif
    Given I am a logged in user
    And there is a root motif
    And there is a root motif with an icon
    And there is a video with a timestamped motif
    When I view the video
    And I click on the first timestamped motif
    Then I should see the scrub with the motif
    When I click the video motif edit
