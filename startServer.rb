require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'openssl'
require_relative 'controller'

set :bind, '0.0.0.0'
set :public_folder, 'public'

before do
    @db = BookmarkDB.new
end

configure do
    enable :sessions
end

get "/logout" do
    session.clear
    redirect "/"
end

get "/admin/audit" do
    if check_admin session[:user]
        erb :adminaudit
    else
        redirect "/dashboard"
    end
end

get "/admin/bookmarks" do
    if check_admin session[:user]
        erb :adminbookmarks
    else
        redirect "/dashboard"
    end
end

get "/admin/users" do
    if check_admin session[:user]
        erb :adminuser
    else
        redirect "/dashboard"
    end
end

get "/" do
    erb :index
end

get "/dashboard" do
    if session[:user] == "" or session[:pass] == ""
        redirect "/login"
    else
        if @db.try_login(session[:user],session[:pass])
            erb :dashboard
        else
            redirect "/login"
        end
    end

end

post "/login" do
    if @db.try_login(params[:email], params[:password])
        session[:user] = params[:email]
        session[:pass] = params[:password]
        redirect "/dashboard"
    else
        redirect "/login"
    end
end

get "/login" do
    if session[:user] != nil and session[:pass] != nil and
        @db.try_login(session[:user], session[:pass])
            redirect "/dashboard"
    else
        erb :login
    end
end

get "/register" do
    @passwordNotMatch = false
    @accountExists = false
    erb :register
end


post "/register" do
    puts params
    if params[:password] == params[:passwordrepeat] # Checks to make sure the
        if !@db.check_account_exists(params[:email])
            @db.create_account(params[:email], params[:password], params[:fname], params[:lname], params[:question], params[:answer]) # Change for username removal
            erb :login
        else
            accountExists = true
            erb :register
        end
    else
        passwordNotMatch = true
        erb :register
        # Use a ruby variable to show an error on the erb
    end
            
    
end

get "/loggedin" do
    if not @db.try_login(session[:user], session[:pass])
        redirect "/"
    else
        @bookmarks = @db.get_all_bookmarks
    end
    if not @db.try_login(session[:user], session[:pass])
        redirect "/"
    else
        @bookmarks = @db.get_all_bookmarks
        erb :bookmarks
    end
end

get "/change-password" do
    if session[:user]
        erb :changePassword
    else
        redirect "/"
    end
end

post "/change-password" do
    puts params 
    puts session[:user]
    puts params[:password]
    session[:changePassMessage] = @db.change_password(session[:user], params[:oldpassword], params[:password], params[:passwordconfirm])
    puts @error
    redirect "/change-password"
end

def check_admin(email)
    if session[:user] != nil
        if @db.is_admin(@db.get_account_id(session[:user]))
            return true
        end
    end
    return false
end