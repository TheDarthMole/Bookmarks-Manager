Feature: register


Scenario: Everything correct
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Successfully created account!"
    
Scenario: Email blank
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with ""
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Email cannot be blank"
    
    
Scenario: Email invalid
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail$gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Not a valid email"
    
    
Scenario: Username blank
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with ""
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Username cannot be blank"
    

Scenario: Password blank
    Given I am on the "register" page
    When I fill in "password" with ""
    When I fill in "passwordConfirm" with ""
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Password cannot be blank"
    
Scenario: Password confirmation blank
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with ""
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Password confirmation cannot be blank"

Scenario: Passwords not matching 
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "nonsense"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Passwords do not match!"

Scenario: Password contains invalid characters
    Given I am on the "register" page
    When I fill in "password" with "🤣"
    When I fill in "passwordConfirm" with "🤣"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password does not meet minimum requirements
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordConfirm" with "123"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Password length should be between 8 to 25 characters and must contain a lowercase letter, an uppercase letter, a number and a special character "
    #here also non-obvious

Scenario: Password too long
    Given I am on the "register" page
    When I fill in "password" with "Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat."
    When I fill in "passwordConfirm" with "Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat."
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious, maybe add sth like 'Passwords not fill conditions' to startSrver.rb?

Scenario: Password contains name
    Given I am on the "register" page
    When I fill in "password" with "john"
    When I fill in "passwordConfirm" with "john"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Password contains consecutive characters(apples double p)
    Given I am on the "register" page
    When I fill in "password" with "11111"
    When I fill in "passwordConfirm" with "11111"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password blank
    Given I am on the "register" page
    When I fill in "password" with "null"
    When I fill in "passwordConfirm" with "null"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Password cannot be blank"

Scenario: Username too long
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordConfirm" with "123"
    When I fill in "username" with "Sed mollis libero ac sapien ullamcorper ullamcorper. nulla ultrices et."
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Username character must be 5 to 50 characters"

Scenario: Username contains invalid characters
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith🤣"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    #When I press "REGISTER" within "form"
    Then I should see "Passwords did not match!"
    
    
Scenario: No answer to question
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with ""
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Answer cannot be blank"
    
        
Scenario: Invalid answer to question
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "asd"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Answer must be 5 to 50 characters"
    
Scenario: No question chosen
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordConfirm" with "secret"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I press "REGISTER"
    #When I press "Submit" within "form"
    Then I should see "Please select a question"