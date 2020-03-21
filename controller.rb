require "sqlite3"
require "openssl"

class BookmarkDB
    
    def initialize
        @db = SQLite3::Database.new "database.db"
        @time = Time.new
    end


    def check_account_exists(username)
        # If get_account_id returns something, there's an account
        # Else return false because no account
        if get_account_id(username)
            return true
        end
        return false
    end
    
    def get_account_id(username)
        statement = "SELECT user_id FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        return retStatement[0]
    end
    
    def try_login(username, password)
        if check_account_exists(username) 
            statement = "SELECT password, salt FROM users WHERE username = ?"
            retStatement = @db.execute(statement, username)[0]
            puts password
            if not password or not username
                puts "Returning early..."
                return false
            end
            puts "Pass=" + password
            puts "Salt=" + retStatement[1]
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
    
    def get_username_email(email)
        statement = "SELECT username FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end
    
    def create_account(username, password, first_name, last_name, email) # Doesn't need account type, seperate function to update
        if not get_account_id(username)
            if not get_username_email(email) ## unique username and email
                hash = generate_hash(password,salt="")
                
                statement = "INSERT INTO users (username, password, salt, first_name, last_name, email) VALUES (?, ?, ?, ?, ?, ?)"
                retStatement = @db.execute statement, username, hash[0], hash[1], first_name, last_name, email
                puts retStatement
                return "successful"
            end
            puts "User tried to make an account with duplicate email #{email}"
            return "fail-email"
        end
        puts "User tried to make an account with duplicate username #{username}"
        return "fail-username"
    end
    
    def upgrade_account_to_admin(username)
        if check_account_exists(username)
            statement = "UPDATE users SET role = 2 WHERE username = ?"
            @db.execute statement, username
        else
            puts "Error upgrading #{username} to admin"
        end
    end
    
    def change_password(username, oldPassword, newPassword)
        if check_account_exists(username)
            if try_login(username, oldPassword)
                hash = generate_hash(newPassword,salt="")
                statement = "UPDATE users SET password = ?, salt = ? WHERE username = ?"
                @db.execute statement, hash[0], hash[1], username
                return "Successful"
            end
            return "Incorrect old password"
        end
        return "Incorrect username"
    end
    
    def add_security_questions(username, sec_question, sec_answer)
        
    end
    
    def get_login_attempts(username)
        statement = "SELECT login_attempts FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        return retStatement[0]
    end
    
    def display_users
        statement = "SELECT * FROM users"
        retStatement = @db.execute statement
            puts "user_id, username, first_name, last_name, email, role, security_question, security_answer, login_attempts, enabled"
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

    def password_check(password)
        if password.length >= 8
                puts "password long enough"
            if password.match? /[a-z]/
                if password.match? /[A-Z]/
                    puts "A-Z"
                    if password.match? /[0-9]/
                        puts "0-9"
                        if password.match? /[!]/
                            puts "pass"
                            return true
                        end
                    end
                end
            end
        end
        puts "password fail"
        return false
    end

    def email_check(email)

    end

# This section is for testing the database
db = BookmarkDB.new
db.display_users



