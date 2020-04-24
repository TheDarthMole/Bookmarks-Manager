require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require_relative 'controller'

require 'minitest/autorun'

class ControllerComparison < Minitest::Test
    #if the database exists
    def initialize_test
        assert_equals true, @db
    end

#check_account_exists
    #with positive value 
    def check_account_exists_test_pos
        assert_equals check_account_exists "Jake1"
    end
    
    #with negative value 
    def check_account_exists_test_neg
        assert_equals check_account_exists "Jake3"
    end
    
    #with empty string 
    def check_account_exists_test_empty
        assert_equals check_account_exists ""
    end
    
    #with nill value  
    def check_account_exists_test_nil
        assert_equals check_account_exists nil
    end

#get_account_id
    #original function
    def get_account_id(username)
        statement = "SELECT user_id FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        return retStatement[0]
    end
   
#try login
    #original function
    def try_login(username, password)
        statement = "SELECT user_id from users WHERE username = ? AND password = ?"
        retStatement = @db.execute statement, username, password
        if retStatement[0]
            return true
        end
            return false
    end


#get_username_email
    #original function
    def get_username_email(email)
        statement = "SELECT username FROM users WHERE email = ?"
        retStatement = @db.execute statement, email
        return retStatement[0]
    end
 

#create_account
    #original function
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
    
    
    #successful case
    #fail email case
    #fail username
    #empty strings
    #null values
    #too long values
    #different characters

#add_security_questions
    #not yet implemented
    def add_security_questions(username, sec_question, sec_answer)
        
    end

#get_login_attempts
    #original function
    def get_login_attempts(username)
        statement = "SELECT login_attempts FROM users WHERE username = ?"
        retStatement = @db.execute statement, username
        return retStatement[0]
    end
  
#display_users 
    #has no return value
    def display_users_test
        puts "display_users has no return value"
    end
end
