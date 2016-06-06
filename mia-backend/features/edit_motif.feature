@javascript
Feature: Edit motif

  Scenario: User changes motif name
    Given I am a logged in user
    And I have created a motif
    When I visit the motif
    And I click the motif edit
    When I enter a motif name
    And I update the motif
    Then I should see the new motif name

  Scenario: User adds icon to motif
    Given I am a logged in user
    And I have created a motif
    When I edit the motif
    And I upload a new icon
    And I update the motif
    Then I should be on the motif page
    And I should see the new icon

  Scenario: move motif to the root
    Given I am a logged in user
    And there is a child motif
    When I edit the motif
    And I remove the parent
    And I update the motif
    And I visit the motifs index
    Then I should see the child motif name

  Scenario: Add video to motif
    Given I am a logged in user
    And there is a child motif
    And the motif has an image
    When I edit the motif
    And I upload a motif video
    And I update the motif
    Then I should be on the motif page
    When the uploaded video has finished processing
    And I visit the motif
    Then I should see the video upload
