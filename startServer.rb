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
        p page_no
        p items_per_page
        a= @db.default_search(search,page_no,items_per_page)
        p a
        return a
    end
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

get "/dashboard/" do
    redirect "/dashboard"
end

get "/dashboard" do
    if check_empty_session
        redirect "/login"
    else
        if @db.try_login(session[:user],session[:pass])
            params[:page] = 1
            erb :dashboard
        else
            redirect "/login"
        end
    end
end

get "/dashboard/:page" do
    if check_empty_session
        redirect "/login"
    else
        if @db.try_login(session[:user],session[:pass])
            @bookmarks = get_bookmarks_page("", params[:page], 5)
            erb :dashboard
        else
            redirect "/login"
        end
    end
end

post "/dashboard" do
    puts params
    if params[:page] == nil
        params[:page] = 1
    end
    if session[:lim] == nil
        session[:lim] = 5
    end
    if params[:searchterm] == ""
        redirect "/dashboard"
    else
        redirect "/dashboard/search/#{params[:searchterm]}/#{params[:page]}/#{session[:lim]}"
    end
end

get "/dashboard/search/:searchterm/:page/:lim" do
    if check_empty_session
        redirect "/login"
    else
        if @db.try_login(session[:user],session[:pass])
            session[:lim] = params[:lim]
            @bookmarks = get_bookmarks_page(params[:searchterm], params[:page], params[:lim])
            erb :dashboard
        else
            redirect "/login"
        end
    end
end

post "/login" do
    if @db.try_login(params[:email].downcase, params[:password])
        session[:user] = params[:email].downcase
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
    erb :register
end


post "/register" do
    puts params
    if params[:password] == params[:passwordrepeat] # Checks to make sure the
        if !@db.check_account_exists(params[:email])
            response = @db.create_account(params[:email], params[:password], params[:fname], params[:lname], params[:question], params[:answer]) # Change for username removal
            p response
            if response == "successful"
                erb :login
            else
                redirect "/register"
            end
        else
#             response = "Account already exists!"
#             p response
            redirect "/register"
        end
    else
#         response = "Passwords do not match!"
#         p response
        erb :register
        # Use a ruby variable to show an error on the erb
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

def check_empty_session()
    if ([nil, ""].include? session[:user]) or ([nil, ""].include? session[:pass])
        return true
    end
    return false
end