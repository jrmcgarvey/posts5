users = [ { email: 'jdoe@example.com', password: 'passw0rd', password_confirmation: 'passw0rd'},
    { email: 'bsmith@example.com', password: 'passw0rd', password_confirmation: 'passw0rd'}]
    
users.each do |u|
    newuser=User.create(u)
    puts newuser.errors.messages
    puts newuser.inspect
    newuser=User.find_by(email: u[:email])
    puts "here's what we find"
    puts newuser.errors.messages
    puts newuser.inspect
    newpost=newuser.posts.create(text: "This is the first post from " + newuser.email)
    puts "but the creation of the post fails"
    puts newpost.errors.messages
    puts newpost.inspect
end
