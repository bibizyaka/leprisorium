#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db

  @db = SQLite3::Database.new 'Leprosorium.db'
  @db_results_as_hash = true #Results will be returned as HASH and not as ARRAY

end

before  do
   
    init_db # start function with connecting to our DB
end

configure do 
    
    init_db 
    @db.execute 'CREATE TABLE IF NOT EXISTS "Posts"
               (
                
	                Id INTEGER PRIMARY KEY AUTOINCREMENT,
	                Created_date DATE,
	     			content TEXT,
	     			author TEXT

     			)'
    @db.execute 'CREATE TABLE IF NOT EXISTS "Comments"
               (
                
	                Id INTEGER PRIMARY KEY AUTOINCREMENT,
	                Created_date DATE,
	     			content TEXT,
	     			post_id INTEGER

     			)'

end

get '/' do

	@results = @db.execute 'Select * from Posts order by id desc'
	erb :index
end 

get '/new' do 

	erb :new
end

post '/new'do

   @content = params[:content]
   @author = params[:author]
   
   if @author.strip.size == 0 

	  @error = "Enter Your Name"
      erb :new
   
   elsif @content.strip.size == 0 

	  @error = "Post Message can't be empty!"
      erb :new
   else

      @db.execute 'Insert into Posts (content, Created_date, author) values ( ? , datetime(), ?) ',[@content, @author]
      redirect to '/'
   end

end #/new 

get '/details/:post_id' do
 
    post_id  = params[:post_id]
	posts = @db.execute "select * from Posts where id = ?",[post_id]
    @post = posts[0] # take the first comment only

    # get comment for selected post message
       
    @comments = @db.execute "select * from Comments where post_id = ? order by id", [post_id]
    
    erb :details
    
end

post '/details/:post_id' do

   post_id = params[:post_id]
   content = params[:content]
   if (content.strip.size == 0)
   	
   	  @error = "Comment cannot be empty!"
      #erb :details
   else

      @db.execute 'Insert into Comments (content, created_date, post_id) values (?,datetime(),?)',[content,post_id]
      redirect ('/details/' + post_id)
  end

end #post details