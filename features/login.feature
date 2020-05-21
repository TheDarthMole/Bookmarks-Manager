Feature: login
#Scenario: Password entry failed multiple times

Scenario: Correct login procedure
    Given I am on the "login" page
    When I fill in "email" with "smmalinowski1@sheffield.ac.uk"
    When I fill in "password" with "Password1!"
    When I press "LOGIN"
    Then I should see "ADD NEW"
    Then I should see "FAVOURITES"

Scenario: Password invalid 
    Given I am on the "login" page
    When I fill in "email" with "smmalinowski1@sheffield.ac.uk"
    When I fill in "password" with "nonsense"
    When I press "LOGIN"
    Then I should see "You have entered incorrect credentials"

Scenario: Username invalid 
    Given I am on the "login" page
    When I fill in "email" with "nonsense"
    When I fill in "password" with "Password1!"
    When I press "LOGIN"
    Then I should see "You have entered incorrect credentials"

Scenario: Password forgotten
    Given I am on the "login" page
    When I go to "Forgot Password?"
    Then I should see "Enter email to recover password"









