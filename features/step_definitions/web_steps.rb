

#Given steps
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Given /^(?:I) am logged in?$/ do
    visit path_to("login")
    fill_in("email", :with => "smmalinowski1@sheffield.ac.uk")
    fill_in("password", :with => "Password1!")
    find("button", :text => "LOGIN").click
end

#When steps
When /^(?:I) fill in "([^\"]*)" with "([^\"]*)"?$/ do |field, value|
    fill_in(field, :with => value)
end

When /^(?:I) check "([^\"]*)"?$/ do |field|
    check(field)
end

When /^(?:I) pick "([^\"]*)" within "([^\"]*)"?$/ do |value, selector|
    select_option(selector, value)
end

When /^(?:I) press "([^\"]*)" within "([^\"]*)"?$/ do |button, selector|
    find(:tag => selector).find(:text => button).click
end
    
When /^(?:I) press "([^\"]*)"?$/ do |button|
    find("button", :text => button).click
end

When /^(?:I) press "([^\"]*)" to save?$/ do |button|
    find("button", :id => button).click
end

When /^(?:I) go to "([^\"]*)"?$/ do |link|
    find("a", :text => link).click
end


#Then steps
Then /^(?:|I) should get redirected to "([^\"]*)"$/ do |path|
    if page.respond_to? :should
        current_path.should == path
    else
        assert current_path.should == path    
    end
end

Then /^(?:|I) should get "([^\"]*)" alert?$/ do  |text|
   find("div", :id => "alert").should have_content(text)     
end

Then /^(?:|I) delete bookmark alert?$/ do 
   find("div", :id => "alert").should have_content(text)     
end

Then /^(?:|I) should see "([^\"]*)"?$/ do  |text|
   page.should have_content(text)     
end

Then /^(?:|I) should see "([^\"]*)" popup?$/ do  |text|
    message = page.find("#link_url").native.attribute("validationMessage")
    expect(message).to eq "Please fill out this field."

end


#helper functions
def find_click_button(name, location)
    find(:text => location).find(:id => name).click
end

def select_option(css_selector, value)
    find(:id => css_selector).find("option[value='#{value}']").select_option
end
