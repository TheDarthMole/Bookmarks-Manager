Feature: view


Scenario: No boxes selected


Scenario: Invalid date format entered
#where can I find date in dashboard.erb?
    Given I am on the "home" page
    When I fill in "date" with "2019/03/02"
    When I press "enter" within "form"
    Then I should see "Wrong date."

Scenario: Future date entered
    Given I am on the "home" page
    When I fill in "date" with "30/03/2040"
    When I press "enter" within "form"
    Then I should see "Wrong date."




