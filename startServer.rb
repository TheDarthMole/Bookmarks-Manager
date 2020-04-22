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

helpers do # functions used within erb files
    def get_bookmarks_page(search, page_no, items_per_page)
        return @db.default_search(search,page_no,items_per_page)
    end
    
    def get_total_items(search)
        return @db.get_total_results search
    end
    
    def check_admin(email)
        return @db.is_admin(@db.get_account_id(email))
    end
end

get "/logout" do
    session.clear
    redirect "/"
end

get "/admin/audit" do
    adminauthenticate
    erb :adminaudit
end

get "/admin/bookmarks" do
    adminauthenticate
    erb :adminbookmarks
end

get "/admin/users" do
    adminauthenticate
    erb :adminuser
end

get "/" do
    erb :index
end

get "/dashboard/" do
    redirect "/dashboard"
end

get "/dashboard" do
    authenticate
    params[:page] = 1
    if session[:lim].nil?
        session[:lim] = 5
    end
    erb :dashboard
end

get "/dashboard/:page/:lim" do
    authenticate
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page("", params[:page], 5)
    @total = get_total_items("")
    erb :dashboard
end

get "/dashboard/:page/:lim/" do
    redirect "/dashboard/#{params[:page]}/#{params[:lim]}"
end

post "/dashboard" do
    if params[:page].nil?
        params[:page] = 1
    end
    if session[:lim].nil?
        session[:lim] = 5
    end
    if params[:searchterm] == ""
        redirect "/dashboard"
    else
        redirect "/dashboard/#{params[:page]}/#{session[:lim]}/#{params[:searchterm]}"
    end
end

get "/dashboard/:page/:lim/:searchterm" do
    authenticate
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page(params[:searchterm], params[:page], params[:lim])
    @total = get_total_items(params[:searchterm])
    erb :dashboard
end

get "/admin/bookmarks/:page/:lim/:searchterm" do
    adminauthenticate
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page(params[:searchterm], params[:page], params[:lim])
    @total = get_total_items(params[:searchterm])
    erb :adminbookmarks
end

get "/admin/bookmarks/:page/:lim" do
    adminauthenticate
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page("", params[:page], 5)
    @total = get_total_items("")
    erb :adminbookmarks
end

post "/login" do
    if @db.try_login(params[:email].downcase, params[:password])
        session[:user] = params[:email].downcase
        session[:pass] = params[:password]
        session[:loggedin] = true
        redirect "/dashboard"
    else
        redirect "/login"
    end
end

get "/login" do
    unless session[:loggedin]
        session[:loggedin] = false
    end
    erb :login
end

get "/register" do
    erb :register
end

post "/createbookmark" do
    puts params
end

post "/register" do
    session[:reason] = nil
    if params[:password] == params[:passwordrepeat] # Checks to make sure the
        sqlresponse = @db.create_account(params[:email], params[:password], params[:fname], params[:lname], params[:question], params[:answer]) # Change for username removal
        if sqlresponse == "Successfully created account!"
            erb :login
        end
        session[:reason] = sqlresponse
        p session[:reason]
        redirect "/register"
    else
        session[:reason] = "Passwords did not match!"
        p session[:reason]
        redirect "/register"
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
    session[:changePassMessage] = @db.change_password(session[:user], params[:oldpassword], params[:password], params[:passwordconfirm])
    redirect "/change-password"
end

def authenticate
    unless session[:loggedin]
        redirect "/login"
    end
end

def adminauthenticate
    authenticate
    unless @db.is_admin(@db.get_account_id(session[:user]))
        redirect "/dashboard"
    end
end