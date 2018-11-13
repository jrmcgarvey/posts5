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
            redirect to '/'
        end
    end
    session[:message]="Logon failed."
    redirect to '/logon'
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
       redirect to '/enroll'
   end
    user.save
    session[:email]=params[:email]
    session[:message]= "User " + params[:email] + " was added."
    redirect to '/' 
end

get '/' do
    if !session[:email]
        redirect to '/logon'
    end
    @posts=Post.all
    erb :index
end

post '/post' do
    if session[:email]
        user=User.find_by(email: session[:email])
        user.posts.create(text: params[:post])
        session[:message]="New post created."
    end
    redirect to '/'
end

get '/logoff' do
   session[:email]=nil
   session[:message]="User logged off."
   redirect to '/logon'
end