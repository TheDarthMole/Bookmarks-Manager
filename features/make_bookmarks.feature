Feature: make bookmarks

Background: Simulating the process of bookmark creation

Scenario: Normal case
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "miros"
    When I fill in "bookmark-url" with "http://consequentialrobotics.com/"
    When I fill in "bookmark-tags" with "robots"
    When I press "save-bookmark" to save
    Then I should get "Successfully added bookmark!" alert

Scenario: Link name empty
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-url" with "https://www.codio.com/"
    When I fill in "bookmark-tags" with "cloud"
    When I press "save-bookmark" to save
    Then I should see "Add Bookmark"

Scenario: Link name contains invalid characters
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "codio"
    When I fill in "bookmark-url" with "https://www.codio.com/"
    When I fill in "bookmark-tags" with "cloud"
    When I press "save-bookmark" to save
    Then I should see "Add Bookmark"    
#?

Scenario: Link name is too long
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit."
    When I fill in "bookmark-url" with "https://www.codio.com/"
    When I fill in "bookmark-tags" with "cloud"
    When I press "save-bookmark" to save
    Then I should see "Please use less than 30 characters"

#URL
Scenario: Link URl empty
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "miros"
    When I fill in "bookmark-tags" with "robots"
    When I press "save-bookmark" to save
    Then I should see "Add Bookmark"

Scenario: Link URL too long
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "lorem"
    When I fill in "bookmark-url" with "http://Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus eget cursus dui. Aliquam tincidunt velit sed metus blandit, eget mattis purus ultricies. Aliquam id nisl volutpat, tempor erat proin.com"
    When I fill in "bookmark-tags" with "text"
    When I press "save-bookmark" to save
    Then I should see "URL too long, please make less than 150 characters"

#@javascript
Scenario: Link URL not valid
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "miros"
    When I fill in "bookmark-url" with "/consequentialrobotics.com/"
    When I fill in "bookmark-tags" with "robots"
    When I press "save-bookmark" to save
    Then I should see "Please start the url with http:// or https://"

Scenario: Link URL already in the bookmarks
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    
    When I fill in "bookmark-name" with "emoji"
    When I fill in "bookmark-url" with "https://getemoji.com/"
    When I fill in "bookmark-tags" with "1"
    When I press "save-bookmark" to save
    
    #trying to add second time
    When I press "ADD NEW"
    
    When I fill in "bookmark-name" with "emoji"
    When I fill in "bookmark-url" with "https://getemoji.com/"
    When I fill in "bookmark-tags" with "2"
    When I press "save-bookmark" to save
    
    Then I should see "URL already added"

#tags
Scenario: Link has no tags
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "regular expresions"
    When I fill in "bookmark-url" with "https://regexr.com/"
    When I press "save-bookmark" to save
    Then I should see "Successfully added bookmark!"


Scenario: Link has too many tags
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "capybara"
    When I fill in "bookmark-url" with "https://github.com/teamcapybara/capybara"
    When I fill in "bookmark-tags" with "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus interdum lorem cursus ligula rutrum, at suscipit quam scelerisque. Mauris libero ligula, aliquet gravida egestas a, gravida ac tellus. Praesent et pretium eros. Nunc sit amet bibendum nibh. Nunc ipsum diam, hendrerit ut facilisis nec, varius tristique nulla. Curabitur felis lectus, aliquet at ante rutrum, varius dapibus magna. Phasellus quis ultrices turpis. Donec tempor elit at nibh laoreet, eu auctor odio ornare. Mauris ac mi suscipit, elementum enim tempor, ultrices augue. Nullam mattis lacinia egestas. Duis dictum consectetur ex, ac auctor urna blandit nec. Phasellus aliquet sem felis, quis facilisis odio mollis vitae. Donec suscipit dolor sit amet massa vestibulum, sit amet sodales ante dictum. Ut luctus sapien et libero semper, eget malesuada justo viverra.Donec fermentum bibendum nulla ut sagittis. Sed finibus enim a tortor vulputate, ac consequat dui malesuada. Cras lacus felis, eleifend eget aliquam ut, semper sit amet dolor. Sed sed pellentesque lorem. Aliquam in velit urna. Quisque aliquet, libero a bibendum malesuada, dui purus tincidunt massa, non placerat mi nibh vel lacus. Maecenas eu nibh feugiat ex ornare iaculis vitae a mauris. In tincidunt neque diam, id placerat leo placerat eu. In at mi vel nunc viverra rhoncus. Sed dui ipsum, vulputate ac dignissim mollis, porttitor et ante. Interdum et malesuada fames ac ante ipsum primis in faucibus. Maecenas odio magna, volutpat sed libero quis, faucibus venenatis magna. Sed sed lobortis lorem. Curabitur varius scelerisque suscipit. Vestibulum ac erat blandit, ornare nibh et, porta ipsum."
    When I press "save-bookmark" to save
    Then I should see "Successfully added bookmark!"

Scenario: Tag input is nil 
Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "ruby forum	"
    When I fill in "bookmark-url" with "https://www.ruby-forum.com/"
    When I fill in "bookmark-tags" with "nil"
    When I press "save-bookmark" to save
    
    Then I should see "Successfully added bookmark!"

Scenario: Link has repeated tag
    Given I am logged in
    Given I am on the "dashboard" page
    When I press "ADD NEW"
    When I fill in "bookmark-name" with "cucumber"
    When I fill in "bookmark-url" with "https://cucumber.io/"
    When I fill in "bookmark-tags" with "cucumber cucumber cucumber"
    When I press "save-bookmark" to save
    Then I should see "Successfully added bookmark!"




