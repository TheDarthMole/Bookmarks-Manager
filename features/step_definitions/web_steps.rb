#Given /^(?:|I) am on the "([^\"]*)" page (.+)$/ do |page_name|
 #   visit path_to(page_name)
#end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

#put returns from controller.rb

#or click button
#When /^(?:I) fill in "([^\"]*)" with "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, value, selector|
 #   scope(selector) do
  #      fill_in(field, :with => value)
   # end
#end
 
  

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
    #find(selector).find(:xpath, 'option['value']').select_option

    #within(selector) do
     #   find("option[value='value'']").click
    #end
end

            
#when I press
#generally login or submit

def find_click_button(name, location)
    find(:text => location).find(:id => name).click
end

When /^(?:I) press "([^\"]*)" within "([^\"]*)"?$/ do |button, selector|
    #find(:id => selector).find(:text => button).click
    find(:tag => selector).find(:text => button).click
    #find(:class => selector).find(:text => button).click
    
    
    #find_click_button(button, selector)
    #with_scope(selector) do
     #   click_button(button)
    #end
end
    
When /^(?:I) press "([^\"]*)"?$/ do |button|
    puts "finding text"
    #find('*', text: button).click
    #find(:xpath ,"/form/button[@type = 'submit']").click
    find("button", :text => button).click

    #find(:xpath ,"/form[last()]").click
    #find(:xpath, text: button).click
end

Then /^(?:|I) should get redirected to "([^\"]*)"$/ do |path|
        if page.respond_to? :should
            current_path.should == path
        else
            assert current_path.should == path    
        end
end
    
Then /^(?:|I) should see "([^\"]*)"(?: within "([^\"]*)")?$/ do  |text, selector|
   page.find("#table").should have_content('stuff') 
    with_scope(selector) do
        fill_in(field)
        if page.respond_to? :should
            page.should have_content(text)
        else
            assert page.has_content?(text)
        end
    end
end
