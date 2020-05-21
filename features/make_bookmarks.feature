Feature: make bookmarks


Background: filling with various values

Scenario: Normal case

    #Successfully added bookmark!



Scenario: Link name empty
    Given I am logged in
    #when I press add new
    Given I am on the "dashboard" page
    When I press "add new"
    When I fill in "title" with "secret"
    When I fill in "url" with "secret"
    When I fill in "notes" with "secret"
    When I press "Submit" within "form"
    When I check "favourites"
    Then I should see "Link name empty."

Scenario: Link name contains invalid characters
    #Then I should see "Welcome"
    

Scenario: Link name is too long
#"Please use less than 30 characters"



#URL
@javascript
Scenario: Link URl empty


Scenario: Link URL contains invalid characters


Scenario: Link URL too long
#"URL too long, please make less than 150 characters"

@javascript
Scenario: Link URL not valid
#"Please start the url with http:// or https://" = not seen because handled in js
Then I should see "Please fill out this field"

Scenario: Link URL already in the bookmarks
#"URL already added"

@javascript
Scenario: Nil input
#put value in required format


#tags
Scenario: Link has no tags
    #Successfully added bookmark!


Scenario: Link has too many tags
#at 200 words gets 404 error
#wait, but in the end it's visible


Scenario: Link tags do not match the preset
#probably not needed

Scenario: Tag input is nil 
    #Successfully added bookmark!


Scenario: Link has repeated tag
    #Successfully added bookmark!
#wait, but in the end it's visible




