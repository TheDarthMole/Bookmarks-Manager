module NavigationHelpers


def path_to(page_name)
    case page_name
    
        when /admin-bookmarks/
            "/admin/bookmarks"
        when /dashboard/
            puts "going to dashboard"
            "/dashboard"
        when /register/
            "/register"
        when /change-password/
            "/change-password"
        when /create-bookmark/
            "/createbookmark"
        when /admin-users/
            "/admin/users"
        when /admin-audit/
            "/admin/audit"
        when /home/
            '/'
        when /login/
            '/login'
        when /logout/
            '/logout'
    else 
        raise "Can't find mapping from \"#(page_name)\" to a path. \n"
    end
end
end
    
World (NavigationHelpers)