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
        statement = "SELECT user_id FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end

    def get_account_email(user_id)
        statement = "SELECT email FROM users where user_id=?"
        retStatement = @db.execute statement, user_id
        return retStatement[0]
    end
    
    def try_login(email, password)
        if check_account_exists(email) 
            statement = "SELECT password, salt FROM users WHERE email = ?"
            retStatement = @db.execute(statement, email)[0]
            if not password or not email
                puts "Returning early..."
                puts "try_login password: " + password
                puts "try_login username: " + email
                return false
            end
            hash = generate_hash(password,salt=retStatement[1])
            if hash[0] == retStatement[0]
                puts "Can login"
                return true
            end
            puts "Cant login"
            return false
        else
            return false
        end
    end
    
    def create_account(email, password, first_name, last_name) # Doesn't need account type, seperate function to update
        if not password_check(password)
            return "Insecure password"
        end
        if not email_check(email)
            return "Incorrect Email"
        end
        if not get_account_id(email)
            hash = generate_hash(password,salt="")

            statement = "INSERT INTO users (email, password, salt, first_name, last_name) VALUES (?, ?, ?, ?, ?)"
            retStatement = @db.execute statement, email, hash[0], hash[1], first_name, last_name
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


    #BOOKMARKS AND TAGS

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

    def search_bookmarks(tags, url, owner)

    end
    
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
            puts "Valid email"
            return true
        end
        puts "bad email"
        return false
    end
    
end

# This section is for testing the database
db = BookmarkDB.new


