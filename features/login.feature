Feature: login
#Scenario: Password entry failed multiple times

Scenario: Correct password entered
    Given I am on the "home" page
    When I fill in "password" with "secret"
    When I press "Submit" within "form"
    Then I should see "Welcome"
    Then I should see "You logged into the bookmarks area."

Scenario: Password invalid 
    Given I am on the "home" page
    When I fill in "password" with "nonsense"
    When I press "Submit" within "form"
    Then I should see "Login"
    Then I should see "Password incorrect."

Scenario: Password forgotten
    Given I am on the "home" page
    When I fill in "password" with "nonsense"
    When I press "Login" within "nav"
    Then I should see "Login"
    Then I should see "Username"

Scenario: Username invalid 
    Given I am on the "home" page
    When I fill in "email" with "nonsense"
    When I press "Submit" within "form"
    Then I should see "Login"
    Then I should see "Username incorrect."








