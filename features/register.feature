Feature: register

#missing
# "Account with that email already exists!"
# change password
# "Passwords do not match" (new and new check)
#"New password can't be the same as old password"
#"Insecure password"
#"Successful"
#"Incorrect old password"


#what to do with old code?


Scenario: Everything correct
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Successfully created account!"

Scenario: Password blank
    Given I am on the "register" page
    When I fill in "password" with ""
    When I fill in "passwordConfirm" with ""
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Passwords not matching 
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "nonsense"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Password contains invalid characters
    Given I am on the "register" page
    When I fill in "password" with "🤣"
    When I fill in "passwordConfirm" with "🤣"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password does not meet minimum requirements
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordConfirm" with "123"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password too long
    Given I am on the "register" page
    When I fill in "password" with "Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat."
    When I fill in "passwordConfirm" with "Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat."
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious, maybe add sth like 'Passwords not fill conditions' to startSrver.rb?

Scenario: Password contains name
    Given I am on the "register" page
    When I fill in "password" with "john"
    When I fill in "passwordConfirm" with "john"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Password contains consecutive characters(apples double p)
    Given I am on the "register" page
    When I fill in "password" with "11111"
    When I fill in "passwordConfirm" with "11111"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password null /nil /0 inputs
    Given I am on the "register" page
    When I fill in "password" with "null"
    When I fill in "passwordConfirm" with "null"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Username too long
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordConfirm" with "123"
    When I fill in "username" with "Sed mollis libero ac sapien ullamcorper ullamcorper. nulla ultrices et."
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Username contains invalid characters
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith🤣"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "REGISTER" within "form"
    Then I should see "Passwords did not match!"
