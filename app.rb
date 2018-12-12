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
	     			content TEXT

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

   content = params[:content]
   if content.strip.size == 0

	  @error = "Post Message can't be empty!"
      erb :new
   else

      @db.execute 'Insert into Posts (content, Created_date) values ( ? , datetime()) ',[content]
      redirect to '/'
   end

end