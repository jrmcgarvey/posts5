require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require 'sqlite3'

set :database, "sqlite3:posts.db"

require './models'

enable :sessions

get '/logon' do
    erb :logon
end

post '/logon' do
    user=User.find_by(email: params[:email])
    if user
        if user.authenticate(params[:password])
            session[:email]=params[:email]
            session[:message]="Logon succeeded for " + params[:email]
            redirect '/'
            return nil
        end
    end
    session[:message]="Logon failed."
    redirect '/logon'
end

get '/enroll' do
   erb :enroll
end   

post '/enroll' do
   user=User.new(params)
   if !user.valid?
       errmessage="Errors:<br>"
       user.errors.messages.each do |key, value|
           errmessage += key.to_s + " " + value[0].to_s + "<br>"
        end
       session[:message]=errmessage
       redirect '/enroll'
   end
    user.save
    session[:email]=params[:email]
    session[:message]= "User " + params[:email] + " was added."
    redirect '/' 
end

get '/' do
    if !session[:email]
        redirect '/logon'
        return nil
    end
    @posts=Post.all
    erb :index
end

post '/post' do
    if session[:email]
        user=User.find_by(email: session[:email])
        post_text=params[:post].strip
        post=user.posts.new(text: post_text)
        if !post.valid?
            errmessage="Errors:<br>"
            post.errors.messages.each do |key, value|
                errmessage += key.to_s + " " + value[0].to_s + "<br>"
            end
            session[:message]=errmessage
        else
            post.save
            session[:message]="New post created."
        end
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