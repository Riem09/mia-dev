@javascript
Feature: As a user I want to search videos

  Scenario: Search videos from the search page
    Given there is a video
    And there is a child motif
    And there is a root motif
    And the video has the child motif between 1000 and 2000
    And the video has the root motif between 1500 and 2000
    When I visit the search page
    And I search for the child motif
    And I click Add...
    And I search for the root motif
    Then I should see the video in the search results
