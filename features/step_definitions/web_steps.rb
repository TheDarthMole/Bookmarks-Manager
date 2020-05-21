
Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end


Given /^(?:I) am logged in?$/ do
    #here visit path and do commands, no factoeybot
    visit path_to("login")
    
    #login_as(FactoryBot.create(:user))
end

#or click button
When /^(?:I) fill in "([^\"]*)" with "([^\"]*)"?$/ do |field, value|
    fill_in(field, :with => value)
end
   

#checkbox, select(option, from:selectbox)
When /^(?:I) check "([^\"]*)"?$/ do |field|
    check(field)
end


def select_option(css_selector, value)
    #find('select#time_zone').find("option[value='#{time_zone.name}']").select_option

    find(:id => css_selector).find("option[value='#{value}']").select_option
    #find(:id => css_selector).find(:option, value).select_option
end

When /^(?:I) pick "([^\"]*)" within "([^\"]*)"?$/ do |value, selector|
    select_option(selector, value)
    
end

            
#when I press
#generally login or submit

def find_click_button(name, location)
    find(:text => location).find(:id => name).click
end

When /^(?:I) press "([^\"]*)" within "([^\"]*)"?$/ do |button, selector|
    #find(:id => selector).find(:text => button).click
    find(:tag => selector).find(:text => button).click
   
end
    
When /^(?:I) press "([^\"]*)"?$/ do |button|
   
    find("button", :text => button).click

end

When /^(?:I) go to "([^\"]*)"?$/ do |link|
   
    find("a", :text => link).click

end


Then /^(?:|I) should get redirected to "([^\"]*)"$/ do |path|
        if page.respond_to? :should
            current_path.should == path
        else
            assert current_path.should == path    
        end
end

Then /^(?:|I) should see "([^\"]*)"?$/ do  |text|
   page.should have_content(text)     
end

