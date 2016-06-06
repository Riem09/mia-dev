@javascript
Feature: Delete a motif

  Scenario:
    Given I am a logged in user
    And there is a root motif
    When I edit the root motif
    And I delete the motif
    And I visit the motifs index
    Then I should not see the root motif name