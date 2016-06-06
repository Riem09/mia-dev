@javascript
Feature: Browse videos

  Scenario: Browse published videos
    Given there is a video
    And there is an unpublished video
    When I visit the video index
    Then I should see the video title
    And I should not see the unpublished video title

  Scenario: View a video
    Given there is a video
    When I view the video
    Then I should see the video title

  Scenario: Browse videos with icons
    Given there is a root motif with an icon
    And there is a video with the motif
    When I view the video
    Then I should see the icon
