require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require_relative 'controller'

set :bind, '0.0.0.0'
# set :public_folder, 'public'

configure do
    @@db = BookmarkDB.new
    puts @@db.check_account_exists("Nick")
    enable :sessions
end

get "/" do
    erb :loginPage
end

post "/" do
    session[:user] = params[:username]
    session[:pass] = params[:password]
    if @@db.try_login(session[:user], session[:pass])
        redirect "/loggedin"
    else
        redirect "/"
    end
end

get "/register" do
    erb :register
end

post "/register" do
    if params[:password] == params[:retry-password] # Checks to make sure the
        
    else
        # Use a ruby variable to show an error on the erb
    end
            
    
end

get "/loggedin" do
    if not @@db.try_login(session[:user], session[:pass])
        redirect "/"
    else
        erb :bookmarks
    end
end

post "/loggedin" do
end