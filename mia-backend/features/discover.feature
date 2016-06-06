@javascript
Feature: Discover new video motifs

  Scenario: As a user I want to discover new video motifs
    Given there is a child motif
    And there is a video with the motif
    When I visit the discover page
    Then I should see the latest video motif