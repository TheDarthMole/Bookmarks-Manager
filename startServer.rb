require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'openssl'
include ERB::Util
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
    def upgrade_account_to_admin(id)
        id = id.to_i
        return @db.upgrade_account_to_admin(id)
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
        if email.nil?
            return false
        end
        return @db.is_admin(@db.get_account_id(email))
    end

    def add_to_audit_log(action)
        return @db.add_to_admin_log(@db.get_account_id(session[:user]),action, params[:id].to_i)
    end
    def view_audit_log(page)
        statement = @db.view_audit_log(page,1000)
        return statement
    end
    def total_audit_results
        return @db.total_audit_results[0][0]
    end

    def can_user_do_action(action)
        if session[:user].nil?
            return false
        end
        return @db.can_user_perform_action(@db.get_account_id(session[:user]), action)
    end
    
    def get_tags_for_bookmark(bookmark_id)
        return @db.get_bookmark_tags(bookmark_id)
    end

    #SHOW comments FOR ID
    def show_comment(bookmark_id,page,limit)
        bookmark_id = bookmark_id.to_i
        page = page.to_i
        limit = limit.to_i
        return @db.get_comments_for_bookmark(bookmark_id, page,limit)
    end
    #SHOW DISABLED COMMENTS
    def view_disabled_comment(page)
        page = page.to_i
        return @db.get_comments_for_bookmark("*",page,100)
    end

    #ENABLE COMMENT
    def enable_comment(id)
        id = id.to_i
        return @db.enable_disable_comment(id,1)
    end

    #DISABLE COMMENT
    def disable_comment(id)
        id = id.to_i
        return @db.enable_disable_comment(id,0)
    end

  #Favourites
    def is_user_fav(bookmark_id)
        if session[:user].nil?
            return false
        end
        bookmark_id = bookmark_id.to_i
        return @db.is_user_favourite(@db.get_account_id(session[:user]),bookmark_id)
    end

    def add_favourite(bookmark_id)
        bookmark_id = bookmark_id.to_i
        return @db.add_favourite(@db.get_account_id(session[:user]),bookmark_id)
    end

    def remove_favourite(bookmark_id)
        bookmark_id = bookmark_id.to_i
        return @db.remove_favourite(@db.get_account_id(session[:user]),bookmark_id)

    end

    def get_user_favourites
        return @db.get_user_favourites(@db.get_account_id(session[:user]),0,100)
    end
    
    # Reporting
    def report_comment(comment_id, reason_id)
        user_id = @db.get_account_id(session[:user])
        return @db.report_comment(comment_id.to_i, user_id, reason_id.to_i)
    end
    
    def get_bookmark(bookmark_id)
        return @db.get_bookmark(bookmark_id)
    end
end


get "/rate/:id/:rate" do
    authenticate
    @db.rating_bookmarks(params[:id].to_i,@db.get_account_id(session[:user]),params[:rate].to_i)
    redirect back
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
    session[:lim] = 10
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
    redirect back
end

get "/admin/users/action/:id/downgrade" do
    adminauthenticate
    downgrade_account_to_user(params[:id])
    add_to_audit_log("downgrade to user")
    redirect back
end

get "/admin/users/action/:id/toadmin" do
  adminauthenticate
  upgrade_account_to_admin(params[:id])
  add_to_audit_log("Upgrade to admin")
  redirect back
end

get "/admin/users/action/:id/suspend" do
    adminauthenticate
    suspend_user(params[:id])
    add_to_audit_log("Suspend user")
    redirect back
end

get "/admin/users/action/:id/unsuspend" do
    adminauthenticate
    unsuspend_user(params[:id])
    add_to_audit_log("Unsuspend user")
    redirect back
end

get "/admin/audit/bookmarks/disabled" do
    erb :adminbookmarksdisabled
end

get "/admin/bookmarks/:id/show" do
    @db.enable_bookmark(params[:id].to_i)
    add_to_audit_log("enabled bookmark")
    redirect back
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
    @bookmarks = get_bookmarks_page("", params[:page], params[:lim])
    @total = get_total_items("")
    erb :adminbookmarks
end

get "/admin/audit/bookmarks/reported" do
  adminauthenticate
  erb :bookmarksreported
end

get "/admin/audit/comments/reported" do
  adminauthenticate
  erb :admincommentaudit
end

#GETS RID OF REPORT
get "/admin/audit/bookmarks/reported/remove/:id" do
    adminauthenticate
    @db.remove_report_comment(params[:id].to_i)
    redirect back
end

get "/admin/audit/comment/reported/remove/:id" do
    adminauthenticate
    @db.remove_report(params[:id])
    redirect back
end


get "/deletecomment/:id" do
    adminauthenticate
    @db.enable_disable_comment(params[:id],0)
    @db.reset_comment_reports(params[:id])
    redirect back
end

get "/comment/report/:id" do
  authenticate
  report_comment(params[:id],1)
  redirect back
end


#COMMENTS PAGE LOAD
#
#
get "/comments/:id" do
  string = "/comments/" + params[:id] + "/"
  redirect string

end

get "/comments/:id/" do
  authenticate
  @comment = params[:comment]
  erb :TESTcomment
end

post "/comments/:id/" do
    authenticate
    @comment = params[:comment]

    @db.add_comment(@db.get_account_id(session[:user]),params[:id],@comment)
    erb :TESTcomment
end



get "/unfavourite/:id" do
    authenticate
    remove_favourite(params[:id])
    redirect back
end

get "/favourite" do
  authenticate
  erb :favourites
end

get "/favourite/:id" do
    authenticate
    add_favourite(params[:id])
    redirect back
end

get "/deleteBookmark/:id" do
    authenticate
    @db.disable_bookmark(params[:id])
    redirect back
end

get "/reportBookmark/:id" do
    authenticate
    @db.report_bookmark(params[:id], @db.get_account_id(session[:user]), 10)
    redirect back
end

######
get "/about" do
    erb :about
end 

get "/contact" do
    erb :contact
end


######

get "/" do
    if session[:user]
        erb :dashboard
    else
      erb :index
    end
end


get "/dashboard/" do
    redirect "/dashboard"
end

get "/dashboard" do
  authenticate
    params[:page] = 1
    if session[:lim].nil?
        session[:lim] = 10
    end
    unless session[:reply]
        session[:reply] = nil
    end
    erb :dashboard
end

get "/guest" do
    session[:lim] = 10;
    erb :dashboard
end

get "/guest/:page/:lim" do
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page("", params[:page], params[:lim])
    @total = get_total_items("")
    unless session[:reply]
        session[:reply] = nil
    end
    erb :dashboard
end

get "/guest/:page/:lim/" do
    redirect "/guest/#{params[:page]}/#{params[:lim]}"
end

get "/dashboard/:page/:lim" do
    authenticate
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page("", params[:page], params[:lim])
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
        session[:lim] = 10
    end
    if params[:searchterm] == ""
        redirect "/dashboard"
    else
        redirect "/dashboard/#{params[:page]}/#{session[:lim]}/#{params[:searchterm]}"
    end
end

get "/dashboard/:page/:lim/:searchterm" do
    authenticate
    if params[:searchterm] == "desc" then
      redirect "/dashboard/1/10/http/desc"
    end
    if params[:searchterm] == "asc" then
        redirect "/dashboard/1/10/http/asc"
    end
    session[:lim] = params[:lim]
    @bookmarks = get_bookmarks_page(params[:searchterm], params[:page], params[:lim])
    @total = get_total_items(params[:searchterm])
    erb :dashboard
end

get "/dashboard/:page/:lim/:searchterm/asc" do
    authenticate
    session[:lim] = params[:lim]
    @bookmarks = @db.sort_asc(params[:searchterm], params[:page], params[:lim])
    @total = get_total_items(params[:searchterm])
    erb :dashboard
end

get "/dashboard/:page/:lim/:searchterm/desc" do
    authenticate
    session[:lim] = params[:lim]
    @bookmarks = @db.sort_desc(params[:searchterm], params[:page], params[:lim])
    @total = get_total_items(params[:searchterm])
    erb :dashboard
end

get "/requestReactivation/:reactivateEmail" do
    @db.request_reactivation(params[:reactivateEmail])
    p params[:reactivateEmail]
    session[:reply] = "Account reactivation successfully sent"
    redirect "/login"
end


get "/admin/audit/reactivate" do
    adminauthenticate
    erb :adminbookmarksreactivate
end

get "/admin/audit/reactivate/:user" do
    @db.unsuspend_user(@db.get_account_id(params[:user]))
    @db.remove_request_reactivation(params[:user])
    redirect "/admin/audit/reactivate"
end

post "/login" do
    if @db.try_login(params[:email].downcase, params[:password])
        session[:user] = @db.login_string_to_email (params[:email].downcase)
        session[:pass] = params[:password]
        session[:loggedin] = true
        redirect "/dashboard"
    else
        if @db.check_account_exists(params[:email].downcase)
            if not @db.check_account_enabled(@db.get_account_id(params[:email].downcase))
                session[:reply] = "Your account has been suspended"
                session[:suspendedUser] = @db.login_string_to_email(params[:email].downcase)
            else 
                session[:reply] = "You have entered incorrect credentials, attempts remaining: " + (6 - @db.get_login_attempts(@db.get_account_id(params[:email])).to_i ).to_s
            end
        else
            session[:reply] = "You have entered incorrect credentials"
        end
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

get "/editBookmark/:bookmark_id" do
    authenticate
    erb :editBookmark
end

post "/editBookmark/:bookmark_id" do
    authenticate
    @db.update_bookmark(params[:bookmark_id], params[:name], params[:url])
    @db.remove_all_tags_for_bookmark(params[:bookmark_id])
    params[:tags].split(" ").each do |n|
        @db.add_tag_bookmark(n, params[:bookmark_id])
    end
    redirect "/editBookmark/#{params[:bookmark_id]}"
end


#COMMENTS SECTION
get "/admin/audit/comments" do
    adminauthenticate
    erb :admincomments
end

get "/admin/comments/action/:id/show" do
  adminauthenticate
  enable_comment(params[:id])
  add_to_audit_log("Re-enable comment")
  redirect "/admin/audit/comments"
end

post "/createbookmark" do
    if  can_user_do_action("add") == 0 then redirect "/dashboard" end
    authenticate
    reply = @db.add_bookmark(params[:title], params[:url], @db.get_account_id(session[:user]), params[:tags])
    session[:reply] = reply
    add_to_audit_log("ADD BOOKMARK")
    redirect "/dashboard"
end

post "/register" do
    session[:reason] = nil
    if params[:password] == params[:passwordConfirm] # Checks to make sure the
        sqlresponse = @db.create_account(params[:username],params[:email], params[:password], 
            params[:fname], params[:lname], params[:question], params[:answer]) # Change for username removal
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
        erb :changePassword

end

post "/change-password" do
   @db.change_password(params[:email], params[:oldpassword], params[:password], params[:passwordconfirm])
    redirect "/dashboard"
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
