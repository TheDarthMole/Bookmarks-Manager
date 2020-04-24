Given /^(?:|I ) am on (.+)$/ do |page_name|
    visit path_to(page_name)
end

#or click button
When /^(?:I ) fill in "([^\"]*)" with "([^\"]*)"(?: within "([^\"]*)")?$/ do |field, value, selector|
    scope(selector) do
        fill_in(field, :with => value)
    end
end
   
    
Then /^(?:|I ) should see "([^\"]*)"(?: within "([^\"]*)")?$/ do  |text, selector|
    with_scope(selector) do
        fill_in(field)
        if page.respond_to? :should
            page.should  have_content(text)
        else
            assert page.has_content?(text)
        end
    end
end
            
When /^(?:I ) press "([^\"]*)" within "([^\"]*)" do |button, selector|
    with_scope(selector) do
        click_button(button)
    end
end
    
Then /^(?:|I ) should get redirected to "([^\"]*)"$/ do  |path|
        if page.respond_to? :should
            current_path.should == path
        else
            assert current_path.should == path    
        end
    end
end
    
