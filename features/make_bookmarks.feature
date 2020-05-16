Feature: make bookmarks

#"Successfully added bookmark!"

Scenario: Made a mistake
    #what's supposed to happen? containing invalid characters? idk


Scenario: Link name empty
    Given I am on the "dashboard" page
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
#"Please start the url with http:// or https://"

#"URL already added"


Scenario: Link URl empty


Scenario: Link URL contains invalid characters


Scenario: Link URL too long
#"URL too long, please make less than 150 characters"

Scenario: Link URL not valid


Scenario: Link URL already in the bookmarks


Scenario: Link URL not valid



Scenario: Null input


Scenario: Link has no tags


Scenario: Link has too many tags


Scenario: Link tags do not match the preset


Scenario: Link tags field has uneven number of "#s"




Scenario: Tag input is null / nil / 0


Scenario: Link has repeated tag


Scenario: Link has empty tag





