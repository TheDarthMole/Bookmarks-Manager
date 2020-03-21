require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'openssl'
require_relative 'controller'

set :bind, '0.0.0.0'
# set :public_folder, 'public'

configure do
    enable :sessions
end

before do
    @database = BookmarkDB.new
end

get "/" do
    erb :loginPage
end

post "/" do
    session[:user] = params[:username]
    session[:pass] = params[:password]
    if @database.try_login(session[:user], session[:pass])
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
    if not @database.try_login(session[:user], session[:pass])
        redirect "/"
    else
        @bookmarks = @database.get_all_bookmarks
        erb :bookmarks
    end
end

post "/loggedin" do
end

get "/change-password" do
    erb :changePassword
end