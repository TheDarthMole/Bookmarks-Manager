Feature: admin view

Scenario: User suspended a long time ago #this one is not quite for the acceptance criteria, 
#how to make it from user perspective?
    Given I am on the "homepage" page
    When I fill in "password" with "secret"
    When I press "Submit" within "form"
    Then I should see "Welcome"
    Then I should see "You logged into the bookmarks area."

Scenario: There are many suspended users

Scenario: User suspended only a few minutes ago


Scenario: User suspended was also an admin


Scenario: User suspended was waiting to be approved



Scenario: Guest accounts - no requests


Scenario: Guest accounts -  one request

Scenario: Guest accounts -  many request


Scenario: Guest accounts - denying request
    Given I am on the "admin-users" page
    #where is it in the adminuser.rb?
    When I fill in "password" with "secret"
    When I press "Submit" within "form"
    Then I should see "Guest upgrade request denied"
#this is going ot change

Scenario: Guest accounts - multiple requests from one account


