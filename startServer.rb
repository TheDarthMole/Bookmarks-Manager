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

    def display_users(perm,page,limit,enabled)
        statement = @db.display_users(perm,page.to_i,limit.to_i,enabled)
        return statement
    end
    def total_users(perm,enabled)
        statement = @db.total_user(perm,enabled)
        return statement
    end
    def upgrade_account_to_user(id)
        id = id.to_i
        return @db.upgrade_account_to_user(id)
    end
    def downgrade_account_to_user(id)
        id = id.to_i
        return @db.downgrade_account_to_user(id)
    end

    def suspend_user(id)
        id = id.to_i
        return @db.suspend_user(id)
    end
    def unsuspend_user(id)
        id = id.to_i
        return @db.unsuspend_user(id)
    end
    
    def check_admin(email)
        return @db.is_admin(@db.get_account_id(email))
    end

    def add_to_audit_log(action)
        return @db.add_to_audit_log(session[:user].to_i,action, params[:id].to_i)
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
    session[:lim] = 5
    params[:page] = 1
    erb :adminuser
end

get "/admin/users/:page/:lim" do
    adminauthenticate
    session[:lim] = params[:lim]
    unless session[:reply]
        session[:reply] = nil
    end
    erb :adminuser
end

get "/admin/users/action/:id/upgrade" do
    adminauthenticate
    upgrade_account_to_user(params[:id])
    add_to_audit_log("Upgrade to user")
    redirect "/admin/users"
end

get "/admin/users/action/:id/downgrade" do
    adminauthenticate
    downgrade_account_to_user(params[:id])
    add_to_audit_log("downgrade to user")
    redirect "/admin/users"
end

get "/admin/users/action/:id/suspend" do
    adminauthenticate
    suspend_user(params[:id])
    add_to_audit_log("Suspend user")
    redirect "/admin/users"
end

get "/admin/users/action/:id/unsuspend" do
    adminauthenticate
    unsuspend_user(params[:id])
    add_to_audit_log("Unsuspend user")
    redirect "/admin/users"
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
    unless session[:reply]
        session[:reply] = nil
    end
    erb :dashboard
end

get "/dashboard/:page/:lim" do
    authenticate
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page("", params[:page], 5)
    @total = get_total_items("")
    unless session[:reply]
        session[:reply] = nil
    end
    erb :dashboard
end

get "/dashboard/:page/:lim/" do
    redirect "/dashboard/#{params[:page]}/#{params[:lim]}"
end

post "/dashboard" do
    authenticate
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
    if session[:loggedin]
        redirect "/dashboard"
    end
    erb :login
end

get "/register" do
    erb :register
end

post "/createbookmark" do
    puts params
    reply = @db.add_bookmark(params[:title], params[:url], @db.get_account_id(session[:user]))
    session[:reply] = reply
    redirect "/dashboard"
end

post "/register" do
    session[:reason] = nil
    if params[:password] == params[:passwordrepeat] # Checks to make sure the
        sqlresponse = @db.create_account(params[:email], params[:password], params[:fname], params[:lname], params[:question], params[:answer]) # Change for username removal
        if sqlresponse == "Successfully created account!"
            erb :login
        end
        session[:reason] = sqlresponse
        redirect "/register"
    else
        session[:reason] = "Passwords did not match!"
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
