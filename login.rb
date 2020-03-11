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
    puts "params:" , params
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
#     params[:username]
#     params[:fname]
#     params[:lname]
#     params[:email]
#     params[:password]
#     params[:retry-password]
#     params[:]
    
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