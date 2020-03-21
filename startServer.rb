require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'openssl'
require_relative 'controller'

set :bind, '0.0.0.0'


before do
    @db = BookmarkDB.new
end

configure do
    enable :sessions
end

get "/" do
    erb :loginPage
end

post "/" do
    session[:user] = params[:username]
    session[:pass] = params[:password]
    if @db.try_login(session[:user], session[:pass])
        redirect "/loggedin"
    else
        redirect "/"
    end
end

get "/register" do
    @passwordNotMatch = false
    erb :register
end

post "/register" do
    if params[:password] == params[:retry-password] # Checks to make sure the
        
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

post "/loggedin" do
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
    @error = @db.change_password(session[:user], params[:oldpassword], params[:password], params[:passwordconfirm])
    puts @error
    redirect "/change-password"
end