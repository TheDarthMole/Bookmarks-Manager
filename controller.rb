require "sqlite3"
require "openssl"

class BookmarkDB
    
    def initialize
        @db = SQLite3::Database.new "database.db"
        @time = Time.new
    end

    #ACCOUNTS
    def check_account_enabled(userid)
        statement = "SELECT enabled FROM users WHERE user_id = ?"
        retStatement = @db.execute statement, userid
        if retStatement[0] != nil
            if retStatement[0][0] == 1
                return true
            end
        end
        return false
    end

    def is_admin(accountID)
        statement = "SELECT role FROM users WHERE user_id = ?"
        retStatement = @db.execute statement, accountID
        if retStatement[0][0] == 2
            return true
        end
        return false
    end
    
    def check_account_exists(email)
        # If get_account_id returns something, there's an account
        # Else return false because no account
        if get_account_id(email)
            return true
        end
        return false
    end
    
    def get_account_id(email)
        email = email.downcase
        statement = "SELECT user_id FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end

    def get_user_role_ID(user_id)
        statement = "SELECT role FROM users WHERE user_id=?"
        retStatement = @db.execute statement, user_id
        return retStatement[0]
    end

    def get_user_role_name(role_id)
        statement = "SELECT role_name FROM permissions WHERE permission_ID=?"
        retStatemnt = @db.execute statement,role_id
        return retStatemnt[0]
    end

    def can_user_perform_action(user_ID,action)
        #pulls user_id role
        role = get_user_role_ID(user_ID)
        #Checks if user can add bookmarks
        hashmap = {"add" => "can_add", "edit" => "can_edit", "create" => "can_create", "manage" => "can_manage", "create_admin" => "can_create_admin", "upgrade_guest" => "can_upgrade_guest"}
        if hashmap.key? action # If the user entered a valid action
            statement = "SELECT #{hashmap[action]} FROM permissions WHERE permission_id = ?"
            if @db.execute(statement, role)[0][0] == 1
                return true
            end
        end
        return false
    end

    def get_account_email(user_id)
        statement = "SELECT email FROM users where user_id=?"
        retStatement = @db.execute statement, user_id
        return retStatement[0]
    end
    
    def check_username_exists(username)
        statement = "SELECT username FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        if retStatement[0]
            return true
        else
            return false
        end
    end
    
    def get_email_from_username(username)
        statement = "SELECT email FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        return retStatement[0][0]
    end
    
    def login_string_to_email(login_name)
        if check_username_exists(login_name)
            return @db.execute("SELECT email FROM users WHERE username = ?", login_name)[0][0]
        elsif check_account_exists(login_name)
            return login_name
        else
            return false
        end
    end
    
    def try_login(login_name, password)
        if login_name.nil? or password.nil?
            return false
        end
        login_name = login_name.downcase
        
        if check_account_exists(login_name) or check_username_exists(login_name)
            if check_username_exists(login_name)
                account_id = get_account_id(get_email_from_username(login_name))
            else
                account_id = get_account_id(login_name)
            end
            unless check_account_enabled(account_id)
                increment_login_attempts(account_id)
                return false
            end
            if get_login_attempts(account_id).to_i > 4
                suspend_user(account_id, "Login Attempts")
                return false
            end
            if check_username_exists(login_name)
                statement = "SELECT password, salt FROM users WHERE username = ?"
            else
                statement = "SELECT password, salt FROM users WHERE email = ?"
            end
            retStatement = @db.execute(statement, login_name)[0]
            if not password or not login_name
                increment_login_attempts(account_id)
                return false
            end
            hash = generate_hash(password,salt=retStatement[1])
            if hash[0] == retStatement[0]
                reset_login_attempts(account_id)
                return true
            end
            increment_login_attempts(account_id)
            return false
        end
        return false
    end

    
    def get_username_email(email)
        statement = "SELECT username FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end

    
    def create_account(username, email, password, first_name, last_name, sec_question, sec_answer) # Doesn't need account type, seperate function to update
        password_reason = password_check(password)
        unless password_reason == true
            return password_reason
        end
        unless email_check(email)
            return "Invalid email format"
        end
        unless plain_text_check(username)
            return "username is greater than 30"
        end
        email = email.downcase
        username = username.downcase
        unless check_account_exists(email)
            unless check_username_exists(username)
                hash = generate_hash(password,salt="") # salt="" means a new one is generated
                statement = "INSERT INTO users (username, email, password, salt, first_name, last_name, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                retStatement = @db.execute statement, username, email.downcase, hash[0], hash[1], first_name, last_name, sec_question, sec_answer
                return "Successfully created account!"
            end
            return "Account with that username already exists!"
        end
        puts "User tried to make an account with duplicate email #{email}"
        return "Account with that email already exists!"
    end
    
    def upgrade_account_to_admin(userID)
        z = get_user_role_ID(userID)
        if z[0] == 3
            statement = "UPDATE users SET role = 2 WHERE user_id = ?"
            @db.execute statement, userID
        else
            puts "Error upgrading #{userID} to admin"
        end
    end

    def upgrade_account_to_user(userID)
            statement = "UPDATE users SET role = 3 WHERE user_id = ?"
            return @db.execute statement, userID
    end

    def downgrade_account_to_user(userID)
        z = get_user_role_ID(userID)
        if z[0] == 3
            statement = "UPDATE users SET role = 1 WHERE user_id = ?"
            @db.execute statement, userID
            
        else
            puts "Error upgrading #{userID} to guest"
        end
    end
    def suspend_user(userID, *reason)
        if check_account_enabled(userID)
            statement = "UPDATE users SET enabled = 0 WHERE user_id = ?"
            @db.execute statement, userID
            if reason[0]
                add_to_admin_log(userID, "Account Suspended: "+ reason[0])
            else
                add_to_admin_log(userID, "Account Suspended")
            end
        else
            puts "Error suspend #{userID}"
        end
    end
    def unsuspend_user(userID)
        if not check_account_enabled(userID)
            statement = "UPDATE users SET enabled = 1 WHERE user_id = ?"
            @db.execute statement, userID
            reset_login_attempts(userID)
        else
            puts "Error unsuspend, not suspended #{userID}"
        end
    end
    def change_password(email, oldPassword, newPassword, newPasswordCheck)
        if newPassword != newPasswordCheck
            return "Passwords do not match"
        end
        if newPassword == oldPassword
            return "New password can't be the same as old password"
        end
        if not password_check(newPassword)
            return "Insecure password"
        end
        if try_login(email, oldPassword)
            hash = generate_hash(newPassword,salt="")
            statement = "UPDATE users SET password = ?, salt = ? WHERE email = ?"
            @db.execute statement, hash[0], hash[1], email
            return "Successful"
        end
        return "Incorrect old password"
    end
    
    def set_password(user_id, new_password) # For admin use
        hash = generate_hash(new_password,salt="")
        statement = "UPDATE users SET password = ?, salt = ? WHERE user_id = ?"
        @db.execute statement, hash[0], hash[1], user_id
        return "Successful"
    end
    
    def get_login_attempts(user_id)
        statement = "SELECT login_attempts FROM users WHERE user_id = ?"
        retStatement = @db.execute statement, user_id
        return retStatement[0][0]
    end
    
    def increment_login_attempts(user_id)
        current_attempts = get_login_attempts(user_id)
        statement = "UPDATE users SET login_attempts = ? WHERE user_id = ?"
        @db.execute statement, current_attempts + 1, user_id
    end
    
    def reset_login_attempts(user_id)
        statement = "UPDATE users SET login_attempts = 0 WHERE user_id = ?"
        @db.execute statement, user_id
    end
    
    def display_users_all
        statement = "SELECT * FROM users"
        retStatement = @db.execute statement
            puts "user_id, first_name, last_name, email, role, security_question, security_answer, login_attempts, enabled"
        for row in retStatement
            counter=0
            for item in row
                if counter != 2 and counter != 3
                    print item.to_s + "|"
                end
                counter+=1
            end
            puts
        end
    end

    def display_users(perm, page, limit, enabled)
        i_min = (page.to_i - 1) * limit.to_i
        if perm == "*"
            statement ="SELECT user_id,first_name,last_name,email,permissions.role_name FROM users,permissions WHERE enabled = ? AND permissions.permission_id=users.role LIMIT ?,?"
            retStatement = @db.execute statement,enabled,i_min,limit
        else
            statement = "SELECT user_id,first_name,last_name,email, permissions.role_name FROM users,permissions WHERE role=? AND enabled = ? AND users.role=permissions.permission_id LIMIT ?,?"
            retStatement = @db.execute statement,perm,enabled,i_min,limit
        end
        return retStatement
    end

    def total_user(perm,enabled)
        if perm == "*"
            statement ="SELECT COUNT(ALL)FROM users WHERE enabled = ? "
            retStatement = @db.execute statement,enabled
        else
            statement = "SELECT COUNT(ALL) FROM users WHERE role=? AND enabled = ?"
            retStatement = @db.execute statement,perm,enabled
        end
        return retStatement[0][0]
    end
    #Audit_log
    #

    def add_to_admin_log(user_id,action,*affect_id)
        if affect_id[0] == nil
            affect_id = 0
        end
        statement = "INSERT INTO audit_log(user_id,bookmark_id,time,action) VALUES(?,?,?,?)"
        time = @time.strftime("%s")
        @db.execute(statement,user_id,affect_id,time,action)
    end

    def view_audit_log(page,limit)
        page = ((page.to_i) - 1) * limit.to_i
        statement = "SELECT * FROM audit_log ORDER BY time DESC"
        return @db.execute(statement)
    end

    def total_audit_results
        statement = "SELECT COUNT(*) FROM audit_log"
        return @db.execute(statement)
    end


    #TAGS

    
    def search_tag(tag_name)
        statement = "SELECT tag_id FROM tags WHERE name=?"
        retStatement = @db.execute statement,tag_name
        return retStatement[0]
    end

    def get_tag_id(tag_name)
        return @db.execute("SELECT tag_id FROM tags WHERE name=?", tag_name)
    end


    def add_tag_bookmark(tag_name, bookmark_id)
        #Checks tag_length
        unless plain_text_check(tag_name,30)
            return "too long tag name"
        end
        statement = "INSERT INTO tags (name) SELECT ? WHERE NOT EXISTS (SELECT * FROM tags WHERE name = ?)"
        @db.execute statement, tag_name, tag_name
        statement = "INSERT INTO bookmark_tags (bookmark_id, tag_id) VALUES (?, (SELECT tag_id FROM tags WHERE name = ?) )"
        @db.execute statement, bookmark_id, tag_name
    end


    def remove_tag(tag_name, bookmark_id)
        tag_id = get_tag_id(tag_name)
        statement = "DELETE FROM tags WHERE tag_ID=? AND bookmark_ID =?"
        @db.execute statement,tag_id,bookmark_id
    end

    #SEARCH AND DISPLAY

    
    def default_search(term,page,results)
        page = page.to_i
        results = results.to_i
        i_min = (page-1)*results
        search = '%'+term+'%'
        retStatment = "SELECT distinct bookmarks.bookmark_id,bookmarks.bookmark_name,bookmarks.url,bookmarks.creation_time FROM bookmark_tags , bookmarks, tags WHERE (bookmarks.bookmark_name LIKE ? OR (tags.name LIKE ? AND tags.tag_id=bookmark_tags.tag_ID AND bookmark_tags.bookmark_ID=bookmarks.bookmark_id) OR bookmarks.url LIKE ?) AND bookmarks.enabled=1  LIMIT ?,?"
        sql = @db.execute retStatment,search,search,search,i_min,results
        #Adds the tags into results
        i_max = sql.length
        i_min = 0
        while i_min != i_max
            sql[i_min].append(get_bookmark_tags(sql[i_min][0]))
            i_min= 1 + i_min
        end
        return sql
    end
    
    def get_total_results(search)
        term = '%'+search+'%'
        retStatment = "SELECT COUNT(DISTINCT bookmarks.bookmark_id) FROM bookmark_tags , bookmarks, tags WHERE (bookmarks.bookmark_name LIKE ? OR (tags.name LIKE ? AND tags.tag_id=bookmark_tags.tag_ID AND bookmark_tags.bookmark_ID=bookmarks.bookmark_id) OR bookmarks.url LIKE ?) AND bookmarks.enabled=1"
        sql = @db.execute retStatment, term, term, term
        p sql
        return sql[0][0]
    end


    def sort_asc(term,page,results)
        page = page.to_i
        results = results.to_i
        i_min = (page-1)*results
        search = '%'+term+'%'
        retStatment = "SELECT distinct bookmarks.bookmark_id,bookmarks.bookmark_name,bookmarks.url,bookmarks.creation_time FROM bookmark_tags , bookmarks, tags WHERE bookmarks.bookmark_name LIKE ? OR (tags.name LIKE ? AND tags.tag_id=bookmark_tags.tag_ID AND bookmark_tags.bookmark_ID=bookmarks.bookmark_id) OR bookmarks.url LIKE ? AND bookmarks.enabled=1 ORDER BY lower(bookmarks.bookmark_name), bookmarks.bookmark_name ASC LIMIT ?,?"
        sql = @db.execute retStatment,search,search,search,i_min,results
        #Adds the tags into results
        i_max = sql.length
        i_min = 0
        while i_min != i_max
            sql[i_min].append(get_bookmark_tags(sql[i_min][0]))
            i_min= 1 + i_min
        end
        return sql
    end

    def sort_desc(term,page,results)
        page = page.to_i
        results = results.to_i
        i_min = (page-1)*results
        search = '%'+term+'%'
        retStatment = "SELECT distinct bookmarks.bookmark_id,bookmarks.bookmark_name,bookmarks.url,bookmarks.creation_time FROM bookmark_tags , bookmarks, tags WHERE bookmarks.bookmark_name LIKE ? OR (tags.name LIKE ? AND tags.tag_id=bookmark_tags.tag_ID AND bookmark_tags.bookmark_ID=bookmarks.bookmark_id) OR bookmarks.url LIKE ? AND bookmarks.enabled=1 ORDER BY bookmarks.bookmark_name COLLATE NOCASE DESC LIMIT ?,?"
        sql = @db.execute retStatment,search,search,search,i_min,results
        #Adds the tags into results
        i_max = sql.length
        i_min = 0
        while i_min != i_max
            sql[i_min].append(get_bookmark_tags(sql[i_min][0]))
            i_min= 1 + i_min
        end
        return sql
    end

    #Uses bookmark_id to pull tag_names
    def get_bookmark_tags(bookmark_id)
        retStatment = "SELECT tags.name FROM tags,bookmark_tags WHERE bookmark_ID = ? AND tags.tag_id=bookmark_tags.tag_ID"
        return @db.execute(retStatment,bookmark_id)
    end

    #FAVS
    def get_user_favourites(user_id,x,y)
        statement = "SELECT bookmarks.bookmark_id,bookmarks.bookmark_name,bookmarks.url,bookmarks.creation_time FROM favourites, bookmarks WHERE favourites.user_id =? AND favourites.bookmark_id = bookmarks.bookmark_id"
        return @db.execute(statement,user_id)
    end

    def is_user_favourite(user_id,bookmark_id)
        statement = "SELECT favourite_id FROM favourites WHERE user_id=? AND bookmark_id=?"
        reStatement = @db.execute statement,user_id,bookmark_id
        if reStatement[0] != nil
            return true
        end
        return false
    end

    def add_favourite(user_id, bookmark_id)
        statement = "INSERT INTO favourites(user_id,bookmark_id) VALUES(?,?)"
        return @db.execute(statement,user_id,bookmark_id)
    end

    def remove_favourite(user_id,bookmark_id)
        bookmark_id = bookmark_id.to_i
        statement = "DELETE FROM favourites WHERE user_id=? AND bookmark_id =?"
        return @db.execute(statement,user_id,bookmark_id)
    end

    #BOOKMAKRS
    def add_bookmark(bookmarkName, url, owner_id, *tags)
        unless plain_text_check(bookmarkName)
            return "Please use less than 30 characters"
        end
        unless url.match? /https?:\/\/[\S]+/
            return "Please start the url with http:// or https://"
        end
        if check_if_exists(url)
            return "URL already added"
        end
        unless plain_text_check(url, 150)
            return "URL too long, please make less than 150 characters"
        end
        unless tags[0]
            unless plain_text_check(tags, 50)
                return "Please enter tags below 50 characters"
            end
        end
        url = url.downcase
        currentTime = @time.strftime("%s")
        statement = "INSERT INTO bookmarks (bookmark_name, url, owner_id, creation_time, enabled) VALUES (?,?,?,?,1)"
        @db.execute statement, bookmarkName, url, owner_id, currentTime
        bookmark_id = @db.execute "SELECT bookmark_id FROM bookmarks WHERE url = ?", url
        if tags[0][0]
            tags_split = tags[0].downcase.split(" ")
            begin
                tags_split.each do |tag|
                    add_tag_bookmark(tag, bookmark_id[0][0])
                end
            rescue
                $stderr.print
                puts "Something went wrong when creating bookmark with tags: #{tags_split} and bookmark id #{bookmark_id[0][0]}"
                return "Something went wrong!"
            end
        end
        
        return "Successfully added bookmark!"
    end


    def check_if_exists(url)
        statement="SELECT bookmark_name,url FROM bookmarks WHERE url=?"
        retStatment = @db.execute(statement,url)
        if retStatment[0] == nil
            return false
        end
        return true
    end
    
    def get_all_bookmarks
        # Only gets enabled bookmarks
        statement = "SELECT bookmark_name, url, owner_id, creation_time FROM bookmarks WHERE enabled = 1"
        return @db.execute statement
    end

    def get_bookmark(bookmark_id)
        statement = "SELECT bookmark_name,url, owner_id, creation_time FROM bookmarks WHERE enabled=1 AND bookmark_id=?"
        retStatment = @db.execute statement, bookmark_id
        return retStatment[0]
    end

    def update_bookmark(bookmark_id, bookmark_name, url)
        currentTime = @time.strftime("%s")
        statement = "UPDATE bookmarks SET bookmark_name=?, url=?, creation_time =? WHERE bookmark_id = ?"
        @db.execute statement, bookmark_name,url,currentTime,bookmark_id
    end

    def disable_bookmark(bookmark_id)
        statement = "UPDATE bookmarks SET enabled = 0 WHERE bookmark_id = ?"
        @db.execute statement, bookmark_id
    end

    def enable_bookmark(bookmark_id)
        statement = "UPDATE bookmarks SET enabled = 1 WHERE bookmark_id = ?"
        @db.execute statement, bookmark_id
    end

    def get_disabled_bookmarks
        statement = "SELECT bookmark_id, bookmark_name, url FROM bookmarks WHERE enabled = 0"
        return @db.execute statement
    end
        
    def get_user_bookmark(owner_id)
        statement = "SELECT bookmark_name, url, owner_id, creation_time FROM bookmarks WHERE owner_id=?"
        return @db.execute statement, owner_id
    end


    #SECURITY
    def generate_hash(password, salt="")
        if salt == ""
            salt = OpenSSL::Random.random_bytes(16)
        end
        iter = 20000
        hash = OpenSSL::Digest::SHA256.new
        len = hash.digest_length
        key = OpenSSL::KDF.pbkdf2_hmac(password, salt: salt, iterations: iter,
                        length: len, hash: hash)
        return [key, salt]
    end
    
    def exec(statement) # Mainly for testing
        return @db.execute statement
    end

    #Checks password for security, only allows 8+ chars that includes lowercase,Uppercase,numbers and special chars
    def password_check(password)
        if password.length >= 8
            if password.match? /[a-z]/
                if password.match? /[A-Z]/
                    if password.match? /[0-9]/
                        if password.match? /[$&+,:;=?@#|'<>.^*()%!-]/
                            return true
                        else
                            return "No special chars: $ & + , : ; = ? @ # | ' < > . ^ * ( ) % ! - "
                        end
                    else
                        return "No numbers in password"
                    end
                else
                    return "No upper case letters"
                end
            else
                return "No lower case letters"
            end
        else
            return "password is not long enough"
        end
        return false
    end

    #checks if email is valid
    def email_check(email)
        if email.match? /\A[a-z0-9\+\-_\.]+@[a-z\d\-.]+\.[a-z]+\z/i
            if email.length <= 100
                puts "Valid email"
                return true
            end
        end
        puts "bad email"
        return false
    end

    #checks length on input name, default 30 chars
    def plain_text_check(name, *length) # Optional argument length to check for
        lengthcheck = unless length[0].nil? then length[0] else 30 end
        if name.length > lengthcheck
            puts "Too long "
            return false
        end

        if name.match? /[a-z]/ or name.match? /[A-Z]/
            return true
        end
        return false
    end

    #
    #
    # Commenting
    #
    #

    def add_comment(user_id, bookmark_id, comment)
        if (plain_text_check(comment,500))
            statement = "INSERT INTO comments (user_id, bookmark_id, text) VALUES (?,?,?)"
            @db.execute(statement, user_id, bookmark_id, comment)
            return "Added comment"
        end
        return "Comment too long"
    end

    #User "*" to get disabled and then the bookmark_id
    def get_comments_for_bookmark(bookmark_id, page, limit)
        i_min = (page.to_i - 1) * limit.to_i
        if bookmark_id == "*"
            statement ="SELECT comments.user_id,comments.comment_id,comments.text,comments.bookmark_id,bookmarks.bookmark_name FROM comments,bookmarks WHERE comments.enabled = 0 AND bookmarks.bookmark_id=comments.bookmark_id LIMIT ?,?"
            retStatement = @db.execute statement,i_min,limit
        else
            statement = "SELECT user_id,comment_id,text FROM comments WHERE bookmark_id=? AND enabled = 1 LIMIT ?,?"
            retStatement = @db.execute statement,bookmark_id,i_min,limit
        end
        return retStatement
    end

    #Set comment to be disable or disabled
    def enable_disable_comment(comment_id,enable)
        statement = "UPDATE comments SET enabled = ? WHERE comment_id = ?"
        return @db.execute statement, enable, comment_id
    end


    # Reporting
    
    def report_bookmark(bookmark_id, user_id, reason_id)
        statement = "REPLACE INTO reporting_bookmarks (user_id, bookmark_id, reason_id) SELECT ?,?,? WHERE NOT EXISTS (SELECT * FROM reporting_bookmarks WHERE user_id = ? AND bookmark_id = ? LIMIT 1)"
        @db.execute statement, user_id, bookmark_id, reason_id, user_id, bookmark_id
    end

    def remove_report_bookmark(bookmark_id, user_id, reason_id)
        statement = "DELETE FROM reporting_bookmarks WHERE bookmark_id = ? AND user_id = ? AND reason_id = ?"
        @db.execute statement, bookmark_id, user_id, reason_id
    end

    def get_bookmark_reports
        statement = "SELECT reporting_bookmarks.bookmark_id,reporting_bookmarks.user_id,bookmarks.url,bookmarks.bookmark_name,reporting_bookmarks.report_id FROM reporting_bookmarks,bookmarks WHERE bookmarks.bookmark_id=reporting_bookmarks.bookmark_id ORDER BY reporting_bookmarks.bookmark_id DESC"
        return @db.execute statement
    end

    def get_total_reports(bookmark_id)
        statement = "SELECT COUNT(bookmark_id)FROM reporting_bookmarks WHERE bookmark_id = ?"
        return @db.execute statement, bookmark_id
    end

    #REMOVES THE COMMENT REPORT
    def remove_report(report_id)
        statement = "DELETE FROM reporting_comments WHERE report_id = ?"
        @db.execute statement, report_id
    end

    #GETS ALL COMMENT REPORTS
    def get_comment_reports
        statement = "SELECT comments.bookmark_id,reporting_comments.user_id,comments.text,bookmarks.bookmark_name, reporting_comments.report_id,reporting_comments.comment_id FROM reporting_comments,comments,bookmarks WHERE comments.comment_id=reporting_comments.comment_id AND comments.bookmark_id=bookmarks.bookmark_id ORDER BY reporting_comments.comment_id DESC"
        return @db.execute statement
    end

    def reset_comment_reports(comment_id)
        statement = "DELETE FROM reporting_comments WHERE comment_id = ?"
        return @db.execute statement,comment_id
    end


    def get_total_reports(bookmark_id)
        statement = "SELECT COUNT(bookmark_id)FROM reporting_bookmarks WHERE bookmark_id = ?"
        return @db.execute statement, bookmark_id
    end


    def report_comment(comment_id, user_id, reason_id)
        statement = "REPLACE INTO reporting_comments (user_id, comment_id, reason_id) SELECT ?,?,? WHERE NOT EXISTS (SELECT * FROM reporting_comments WHERE user_id = ? AND comment_id = ? LIMIT 1)"
        @db.execute statement, user_id, comment_id, reason_id, user_id, comment_id
    end

    #REMOVES THE BOOKMARK REPORT
    def remove_report_comment(report_id)
        statement = "DELETE FROM reporting_bookmarks WHERE report_id = ?"
        @db.execute statement, report_id
    end

    
end

# This section is for testing the database

db = BookmarkDB.new
(1..6).each do |account| # Makes sure admins can always login
    db.unsuspend_user(account)
#     db.set_password(account,"Password1!")

end
