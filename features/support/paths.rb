module NavigationHelpers


def path_to(page_name)
    case page_name
    
        when /the admin-bookmarks page/
            "/admin/bookmarks"
        when /the dashboard page/
            "/dashboard"
        when /the register page/
            "/register"
        when /the change-password page/
            "/change-password"
        when /the createbookmark page/
            "/createbookmark"
        when /the admin-users page/
            "/admin/users"
        when /the admin-audit page/
            "/admin/audit"
        when /the home\s?page/
            '/'
        when /the login page/
            '/login'
        when /the logout page/
            '/logout'
    else 
        raise "Can't find mapping from \"#(page_name)\" to a path. \n" + 
        
    end   
    end
end
World (NavigationHelpers)