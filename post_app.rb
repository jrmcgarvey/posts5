require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'sqlite3'

set :database, "sqlite3:posts.db"

require './models'

enable :sessions


get '/enroll' do
   erb :enroll
end   

post '/enroll' do
    # todo number 1
    # you need to make a new user object using the values in the parameters
    # then uncomment the lines below
    
#    if !user.valid?
#        errmessage="Errors:<br>"
#        user.errors.messages.each do |key, value|
#           errmessage += key.to_s + " " + value[0].to_s + "<br>"
#        end
#        session[:message]=errmessage
#        redirect '/enroll'
#    end
#    user.save
    session[:email]=params[:email]
    session[:message]= "User " + params[:email] + " was added."
    redirect '/' 
end

get '/logon' do
    erb :logon
end

post '/logon' do
    # todo number 2:
    # you are given parameters with :email and :password.
    # you need to find the user from the :email
    # then you can uncomment the lines below
#    if user
#        if user.authenticate(params[:password])
            session[:email]=params[:email]
            session[:message]="Logon succeeded for " + params[:email]
            redirect '/'
            return nil
#        end
#    end
#    session[:message]="Logon failed."
#    redirect '/logon'
end

get '/' do
    if !session[:email]
        redirect '/logon'
        return nil
    end
#    @posts=Post.all
    erb :index
end

post '/post' do
    if session[:email]
        # todo number 3
        # you need to find the user from the :email
        # that is stored in the session.

        post_text=params[:post].strip
        # todo
        # now that you have the user, you need to create a post from
        # that user, with the text from the post_text variable
        # then uncomment the lines below
        
        #if !post.valid?
        #    errmessage="Errors:<br>"
        #    post.errors.messages.each do |key, value|
        #        errmessage += key.to_s + " " + value[0].to_s + "<br>"
        #    end
        #    session[:message]=errmessage
        #else
        #    post.save
        #    session[:message]="New post created."
        #end
        redirect '/'
        return nil
    else
        redirect 'logon'
    end
end

get '/logoff' do
   session[:email]=nil
   session[:message]="User logged off."
   redirect '/logon'
end