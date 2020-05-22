Feature: register

Background: Simulating the process of new user registration

Scenario: Everything correct
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "username" with "JohnSmith"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "Successfully created account!"
    
Scenario: Email blank
 Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "username" with "JohnSmith"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I fill in "email" with ""
    When I press "REGISTER"
    Then I should see "Invalid email format"
    
    
Scenario: Email invalid
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "username" with "JohnSmith"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail$gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "Invalid email format"
    
    
Scenario: Username blank
    Given I am on the "register" page
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "username" with ""
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "username is greater than 30"
    

Scenario: Password blank
    Given I am on the "register" page
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    Given I am on the "register" page
    When I fill in "password" with ""
    When I fill in "passwordConfirm" with ""
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "password is not long enough"
    
Scenario: Password confirmation blank

    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "passwordConfirm" with ""
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "Passwords did not match"

Scenario: Passwords not matching 
    Given I am on the "register" page
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "password" with "Secret987%"
    When I fill in "passwordConfirm" with "nonsensE4567&"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "Passwords did not match!"

Scenario: Password does not meet minimum requirements

    Given I am on the "register" page
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordConfirm" with "123"
    When I fill in "username" with "JohnSmith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "password is not long enough"
    #Then I should see "Password length should be between 8 to 25 characters and must contain a lowercase letter, an uppercase letter, a number and a special character "

Scenario: Password too long
    Given I am on the "register" page
    When I fill in "username" with "JohnSmith4"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "password" with "123$Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat."
    When I fill in "passwordConfirm" with "123$Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat."
    When I fill in "email" with "sampleemail4@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "Successfully created account!"

Scenario: Password nil
 Given I am on the "register" page
    When I fill in "password" with "nil"
    When I fill in "passwordConfirm" with "nil"
    When I fill in "username" with "JohnSmith"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "password is not long enough"

Scenario: Username too long
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "username" with "Sed mollis libero ac sapien ullamcorper ullamcorper. nulla ultrices et."
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "username is greater than 30"

Scenario: Username too short
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "username" with "123"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "username is greater than 30"

Scenario: No answer to question
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "username" with "JohnSmith2"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail2@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with ""
    When I press "REGISTER"
    Then I should see "Successfully created account!"
    
Scenario: No question chosen
    Given I am on the "register" page
    When I fill in "password" with "Password1!"
    When I fill in "passwordConfirm" with "Password1!"
    When I fill in "username" with "JohnSmith3"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail3@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "qwerty"
    When I press "REGISTER"
    Then I should see "Successfully created account!"