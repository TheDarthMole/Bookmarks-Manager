Scenario: Correct password entered
    Given I am on the homepage
    When I fill in "password" with "secret"
    When I press "Submit" within "form"
    Then I should see "Welcome"
    Then I should see "You logged into the bookmarks area."





Scenario: Password invalid 
    Given I am on the homepage
    When I fill in "password" with "nonsense"
    When I press "Submit" within "form"
    Then I should see "Login"
    Then I should see "Password incorrect."



Scenario: Password entry failed multiple times


Scenario: Password forgotten


Scenario: Username invalid 

