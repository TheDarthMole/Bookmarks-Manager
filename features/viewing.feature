Feature: view

#template
#Given I am on <some page>
#When I press <some button> within <some HTML element / CSS id>
#When I follow <some link> within <some HTML element / CSS id>
#When I fill in <some input element> with <some text> 
#within <some HTML element / CSS id>
##Then I should see <some text> within <some HTML element / CSS id>
#


Scenario: Bookmark list empty



Scenario: Bookmark list contains one item


Scenario: Bookmark list contains many items




Scenario: Dropdown menu has no tags


Scenario: Dropdown menu has empty tags


Scenario: Dropdown menu has just one tag


Scenario: Dropdown menu has many tags




Scenario: Checkbox search: no tags yet


Scenario: Checkbox search: only one tage


Scenario: Checkbox search: similar tags


Scenario: Checkbox search: many tags



Scenario: There are no results


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




