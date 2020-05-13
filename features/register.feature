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
    When I fill in "passwordrepeat" with "secret"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I pick "1" within "question"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Successfully created account!"

Scenario: Password blank
    Given I am on the "register" page
    When I fill in "password" with ""
    When I fill in "passwordrepeat" with ""
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Passwords not matching 
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordrepeat" with "nonsense"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Password contains invalid characters
    Given I am on the "register" page
    When I fill in "password" with "🤣"
    When I fill in "passwordrepeat" with "🤣"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password does not meet minimum requirements
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordrepeat" with "123"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password too long
    Given I am on the "register" page
    When I fill in "password" with "Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat, posuere in urna ac, blandit interdum eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed pharetra dui. Curabitur nulla massa, dignissim ut fermentum eget, accumsan sit amet massa. Curabitur at tortor eu risus ultricies aliquam eu in nunc. Mauris iaculis, sapien sed egestas consequat, erat nibh pulvinar quam, vel viverra metus tortor efficitur diam. Donec eget pulvinar nisl. Vestibulum at ultrices nulla. Suspendisse felis justo, maximus ac aliquet a, euismod et erat. Nam eget enim at eros efficitur tempus. Integer risus urna, sagittis vitae finibus vitae, dignissim eu enim. Integer non dolor massa. Donec at viverra elit. Nulla imperdiet libero magna, sed ullamcorper nulla ultrices et."
    When I fill in "passwordrepeat" with "Sed mollis libero ac sapien ullamcorper ullamcorper. Ut neque erat, posuere in urna ac, blandit interdum eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur sed pharetra dui. Curabitur nulla massa, dignissim ut fermentum eget, accumsan sit amet massa. Curabitur at tortor eu risus ultricies aliquam eu in nunc. Mauris iaculis, sapien sed egestas consequat, erat nibh pulvinar quam, vel viverra metus tortor efficitur diam. Donec eget pulvinar nisl. Vestibulum at ultrices nulla. Suspendisse felis justo, maximus ac aliquet a, euismod et erat. Nam eget enim at eros efficitur tempus. Integer risus urna, sagittis vitae finibus vitae, dignissim eu enim. Integer non dolor massa. Donec at viverra elit. Nulla imperdiet libero magna, sed ullamcorper nulla ultrices et."
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious, maybe add sth like 'Passwords not fill conditions' to startSrver.rb?

Scenario: Password contains name
    Given I am on the "register" page
    When I fill in "password" with "john"
    When I fill in "passwordrepeat" with "john"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Password contains consecutive characters(apples double p)
    Given I am on the "register" page
    When I fill in "password" with "11111"
    When I fill in "passwordrepeat" with "11111"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
    #here also non-obvious

Scenario: Password null /nil /0 inputs
    Given I am on the "register" page
    When I fill in "password" with "null"
    When I fill in "passwordrepeat" with "null"
    When I fill in "fname" with "John"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Username too long
    Given I am on the "register" page
    When I fill in "password" with "123"
    When I fill in "passwordrepeat" with "123"
    When I fill in "fname" with "Sed mollis libero ac sapien ullamcorper ullamcorper. nulla ultrices et."
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"

Scenario: Username contains invalid characters
    Given I am on the "register" page
    When I fill in "password" with "secret"
    When I fill in "passwordrepeat" with "secret"
    When I fill in "fname" with "John🤣"
    When I fill in "lname" with "Smith"
    When I fill in "email" with "sampleemail@gmail.com"
    When I fill in "question" with "1"
    When I fill in "answer" with "xyz"
    When I press "Submit" within "form"
    Then I should see "Passwords did not match!"
