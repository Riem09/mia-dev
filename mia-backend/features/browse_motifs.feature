@javascript
Feature: Browse motifs

  Scenario: Browse root motifs
    Given there is a root motif
    When I visit the motifs index
    Then I should see the root motif name

  Scenario: View motif
    Given there is a root motif
    When I visit the root motif
    Then I should see the root motif details

