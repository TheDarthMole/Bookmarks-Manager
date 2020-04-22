module NavigationHelpers


def path_to(page_name)
    case page_name
    
        
        
        "/change-password"
        "/register"
        "/createbookmark"
        "/login"
        "/admin/users"
        "/admin/bookmarks"
        "/admin/audit"
        "/logout"
        
        "/dashboard"
        "/dashboard/:page"
        "/dashboard/search/:searchterm/:page/:lim"
        
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