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

get "/admin" do
    erb :adminuser
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
    session[:user] = params[:email]
    session[:pass] = params[:password]
    puts session[:user]
    puts session[:pass]
    if @db.try_login(session[:user], session[:pass])
        redirect "/dashboard"
    else
        redirect "/login"
    end
end

get "/login" do
    erb :login
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
#             @db.create_account(username, password, first_name, last_name, email) # Change for username removal
#             @db.add_security_questions(params[:email], params[:question], params[:answer])
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