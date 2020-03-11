require "sqlite3"

class BookmarkDB
    
    def initialize
        @db = SQLite3::Database.new "./database.db"
    end

    def check_account_exists(username)
        # If get_account_id returns something, there's an account
        # Else return false because no account
        if get_account_id(username)
            return true
        else
            return false
        end
    end
    
    def get_account_id(username)
        statement = "SELECT user_id FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        return retStatement[0]
    end
    
    def try_login(username, password)
        statement = "SELECT user_id from users WHERE username = ? AND password = ?"
        retStatement = @db.execute statement, username, password
        if retStatement[0]
            return true
        end
            return false
    end
    
    def get_username_email(email)
        statement = "SELECT username FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end
    
    def create_account(username, password, first_name, last_name, email) # Doesn't need account type, seperate function to update
        if not get_account_id(username)
            if not get_username_email(email) ## unique username and email
                statement = "INSERT INTO users (username, password, first_name, last_name, email) VALUES (?, ?, ?, ?, ?)"
                retStatement = @db.execute statement, username, password, first_name, last_name, email
                puts retStatement
                return "successful"
            end
            return "fail-email"
        end
        return "fail-username"
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
            puts "user_id, username, password, first_name, last_name, email, role, security_question, security_answer, login_attempts, enabled"
        for row in retStatement
            for item in row
                print item.to_s + "|"
            end
            puts
        end
    end
    
    
    
end

db = BookmarkDB.new
db.display_users
# puts db.create_account("Jake1","Jake123","Jake","Robison","JakeRobison@gmail.com")
# # puts db.check_account_exists("Nicki")
# puts db.try_login("Nick","password1")