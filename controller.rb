require "sqlite3"
require "openssl"

class BookmarkDB
    
    def initialize
        @db = SQLite3::Database.new "database.db"
        @time = Time.new
    end

    def check_account_enabled(email)
        statement = "SELECT enabled FROM users WHERE user_id = ?"
        retStatement = @db.execute statement, email
        if retStatement[0][0] == 1
            return true
        else
            return false
        end
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
        if action == "add"
            return @db.execute("SELECT can_add FROM permissions WHERE permission_id=?",role)
        end
        #checks if user can edit
        if action == "edit"
            return @db.execute("SELECT can_edit FROM permissions WHERE permission_id=?",role)
        end
        #checks if user can create
        if action == "create"
            return @db.execute("SELECT can_create FROM permissions WHERE permission_id=?",role)
        end
        #checks if user can manage
        if action == "manage"
            return @db.execute("SELECT can_manage FROM permissions WHERE permission_id=?",role)
        end
        #checks if user can create_admin
        if action == "create_admin"
            return @db.execute("SELECT can_create_admin FROM permissions WHERE permission_id=?",role)
        end
        #checks if user can upgrade_guest
        if action == "upgrade_guest"
            return @db.execute("SELECT can_upgrade_guest FROM permissions WHERE permission_id=?",role)
        end
        puts "NO WORKABLE ACTION"
        return false
    end

    def get_account_email(user_id)
        statement = "SELECT email FROM users where user_id=?"
        retStatement = @db.execute statement, user_id
        return retStatement[0]
    end
    
    def try_login(email, password)
        if email.nil? or password.nil?
            return false
        end
        email = email.downcase
        if check_account_exists(email)
            statement = "SELECT password, salt FROM users WHERE email = ?"
            retStatement = @db.execute(statement, email)[0]
            if not password or not email
                return false
            end
            hash = generate_hash(password,salt=retStatement[1])
            if hash[0] == retStatement[0]
                puts "Can login"
                return true
            end
            puts "Cant login"
            return false
        end
        return false
    end
    
    def get_username_email(email)
        statement = "SELECT username FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end
    
    def create_account(email, password, first_name, last_name, sec_question, sec_answer) # Doesn't need account type, seperate function to update
        if not password_check(password)
            return "Insecure password"
        end
        if not email_check(email)
            return "Incorrect Email"
        end
        if not get_account_id(email)
            hash = generate_hash(password,salt="") # salt="" means a new one is generated

            statement = "INSERT INTO users (email, password, salt, first_name, last_name, security_question, security_answer) VALUES (?, ?, ?, ?, ?, ?, ?)"
            retStatement = @db.execute statement, email.downcase, hash[0], hash[1], first_name, last_name, sec_question, sec_answer
            puts retStatement
            return "successful"
        end
        puts "User tried to make an account with duplicate email #{email}"
        return "fail-email"
    end
    
    def upgrade_account_to_admin(email)
        if check_account_exists(email)
            statement = "UPDATE users SET role = 2 WHERE email = ?"
            @db.execute statement, email
        else
            puts "Error upgrading #{email} to admin"
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
            puts hash[0]
            puts hash[1]
            statement = "UPDATE users SET password = ?, salt = ? WHERE email = ?"
            puts @db.execute statement, hash[0], hash[1], email
            return "Successful"
        end
        return "Incorrect old password"
    end
    #
    def add_security_questions(email, sec_question, sec_answer)
        
    end
    
    def get_login_attempts(user_id)
        statement = "SELECT login_attempts FROM users WHERE user_id = ?"
        retStatement = @db.execute statement, user_id
        return retStatement[0]
    end
    
    def display_users
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
        #check if tag exists
        if not get_tag_id(tag_name)
            @db.execute("INSERT INTO tags(name) VALUES (?)", tag_name)
        end
        tag_id = get_tag_id(tag_name)
        statement = "INSERT INTO bookmark_tags (?,?)"
        retStatement = @db.execute statement, tag_id, bookmark_id
        return retStatement
    end


    def remove_tag(tag_name, bookmark_id)
        tag_id = get_tag_id(tag_name)
        statement = "DELETE FROM tags WHERE tag_ID=? AND bookmark_ID =?"
        @db.execute statement,tag_id,bookmark_id
    end

    #SEARCH AND DISPLAY
    #
    #
    def default_search(term,page,results)
        page = page.to_i
        results = results.to_i

        i_min = (page-1)*results

        search = '%'+term+'%'
        retStatment = "SELECT distinct bookmarks.bookmark_id,bookmarks.bookmark_name,bookmarks.url,bookmarks.creation_time FROM bookmark_tags , bookmarks, tags WHERE bookmarks.bookmark_name LIKE ? OR (tags.name LIKE ? AND tags.tag_id=bookmark_tags.tag_ID AND bookmark_tags.bookmark_ID=bookmarks.bookmark_id) OR bookmarks.url LIKE ? LIMIT ?,?"
        sql = @db.execute retStatment,search,search,search,i_min,results
        return sql
    end
    
    def get_total_results(search)
        term = '%'+search+'%'
        retStatment = "SELECT COUNT(DISTINCT bookmarks.bookmark_id) FROM bookmark_tags , bookmarks, tags WHERE bookmarks.bookmark_name LIKE ? OR (tags.name LIKE ? AND tags.tag_id=bookmark_tags.tag_ID AND bookmark_tags.bookmark_ID=bookmarks.bookmark_id) OR bookmarks.url LIKE ?"
        sql = @db.execute retStatment, term, term, term
        return sql[0][0]
    end
    #Uses results array to pull tag_names
    def get_bookmark_tags(array)
        i_max = array.length
        i_min = 0
        retStatment = "SELECT bookmark_ID,tags.name FROM tags,bookmark_tags WHERE bookmark_ID = ? AND tags.tag_id=bookmark_tags.tag_ID"
        tags = []
        while i_min != i_max
            tags.append(@db.execute(retStatment,array[i_min][0]))
            i_min= 1 + i_min
        end
        p tags
        return tags
    end

    def search_tags_bookmarks(tag_name)
        #gets tag_id based on name
        tag_id = get_tag_id(tag_name)
        #saves array of bookmarks with tag_ID
        bookmark_id_list = @db.execute("SELECT bookmark_ID FROM bookmark_tags where tag_ID =?", tag_id)
        bookmark_list=[]
        #goes through bookmark ID
        bookmark_id_list.each { |i|
            bookmark_list.append(get_bookmark(i))
        }
        #debug code
        p bookmark_list
        return bookmark_list
    end

    def search_owner_bookmarks(owner)
        #gets user_id based on name
        owner_id = @db.execute("SELECT user_id FROM users WHERE first_name=? OR last_name=?", owner,owner)
        bookmark_list=[]
        owner_id.each do
            |i|
            bookmark_list.append(get_user_bookmark(i))
        end
        return bookmark_list
    end

    def search_url_bookmarks(url)
        #makes it a wildcard search
        search = '%'+url+'%'
        statement = "SELECT bookmark_name, url, creation_time FROM bookmarks WHERE url LIKE ? AND enabled=1"
        retStatement = @db.execute statement,search
        #debug
        p retStatement
        return retStatement
    end

    def get_bookmarks(page,result_per_page)
        result =[]
        i_min = (page-1)*result_per_page
        i_max = page*result_per_page
        while i_min != i_max
            result.append(@db.execute("SELECT bookmark_name,url,creation_time WHERE bookmark_id=?",i_min))
            i_min = i_min+1
        end
        return result
    end
    #creates an array to display based on page number
    def display_bookmarks(array, page_number, number_results)
        i_max = page_number * number_results
        i_min = (page_number-1) * number_results
        results = []
        while i_min != i_max
            results.append(array[i_min])
            i_min = 1 + i_min
            #debug
            p i_min
            p i_max
            p results
        end
        return results
    end



    #BOOKMAKRS
    def add_bookmark(bookmarkName, url, owner_id)
        currentTime = @time.strftime("%s")
        statement = "INSERT INTO bookmarks (bookmark_name, url, owner_id, creation_time, enabled) VALUES (?,?,?,?,1)"
        @db.execute statement, bookmarkName, url, owner_id, currentTime
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

    def remove_bookmark(bookmark_id)
        statement = "DELETE FROM database WHERE bookmark_id =? "
        @db.execute statement, bookmark_id
    end

    def get_user_bookmark(owner_id)
        statement = "SELECT bookmark_name, url, owner_id, creation_time FROM bookmarks WHERE owner_id=?"
        return @db.execute statement, owner_id
    end


    def add_sample_data
        add_bookmark("Facebook","https://facebook.com",1)
        add_bookmark("Instagram","https://instagram.com",1)
        add_bookmark("Reddit","https://reddit.com",1)
        add_bookmark("Messenger","https://messenger.com",1)
        add_bookmark("Youtube","https://youtube.com",1)
        add_bookmark("Google","https://google.com",1)
        add_bookmark("Github","https://github.com",1)
        db.create_account("Nick","Password","Nick","Ruffles","nruffles1@sheffield.ac.uk")
        db.upgrade_account_to_admin("Nick")

        db.create_account("Jake","Password","Jake","Robison","jrobison1@sheffield.ac.uk")
        db.upgrade_account_to_admin("Jake")

        db.create_account("Anna","Password","Anna","Penny","afpenny1@sheffield.ac.uk")
        db.upgrade_account_to_admin("Anna")

        db.create_account("Stan","Password","Stanislaw","Malinowski","smmalinowski1@sheffield.ac.uk")
        db.upgrade_account_to_admin("Stan")

        db.create_account("Abdul","Password","Abdulrahman","AlTerkait","aalterkait1@sheffield.ac.uk")
        db.upgrade_account_to_admin("Abdul")

        db.create_account("Lujain","Password","Lujain","Hawsawi","lhawsawi2@sheffield.ac.uk")
        db.upgrade_account_to_admin("Lujain")
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
                            puts "pass"
                            return true
                        else
                            puts "No special chars: $ & + , : ; = ? @ # | ' < > . ^ * ( ) % ! - "
                        end
                    else
                        puts "No numbers in password"
                    end
                else
                    puts "No upper letters"
                end
            else
                puts "No lower case letters"
            end
        else
            puts "password is not long enough"
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

    def plain_text_check(name)
        if name.length > 30
            puts "long name"
            return false
        end

        if name.match? /[a-z]/ or name.match? /[A-Z]/
            return true
        end

        return false
    end
    
end

# This section is for testing the database
db = BookmarkDB.new
db.get_total_results("google")